from __future__ import annotations

import importlib.util
import io
import json
import sys
import tempfile
import unittest
from contextlib import redirect_stdout
from pathlib import Path

SCRIPT = Path(__file__).parents[1] / "scripts" / "sdk_api_check.py"
SPEC = importlib.util.spec_from_file_location("sdk_api_check", SCRIPT)
assert SPEC and SPEC.loader
sdk_api_check = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = sdk_api_check
SPEC.loader.exec_module(sdk_api_check)


def make_fake_sdk(root: Path) -> Path:
    sdk = root / "iPhoneOS27.0.sdk"
    uikit = sdk / "System/Library/Frameworks/UIKit.framework"
    (uikit / "Headers").mkdir(parents=True)
    (uikit / "Headers/UIBarMinimization.h").write_text(
        "/// Access this configuration through navigationBarMinimization\n"
        "@property (nonatomic, readwrite, copy) UIBarMinimization *navigationBarMinimization "
        "API_AVAILABLE(ios(27.0));\n",
        encoding="utf-8",
    )
    swiftui = sdk / "System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule"
    swiftui.mkdir(parents=True)
    (swiftui / "arm64-apple-ios.swiftinterface").write_text(
        "@available(iOS 27.0, *)\npublic func visibilityPriority(_ p: Priority) -> some ToolbarContent\n",
        encoding="utf-8",
    )
    # A second architecture must not be double counted or preferred.
    (swiftui / "x86_64-apple-ios-simulator.swiftinterface").write_text("axisBehavior\n", encoding="utf-8")
    return sdk


class SdkApiCheckTests(unittest.TestCase):
    def setUp(self) -> None:
        self._directory = tempfile.TemporaryDirectory()
        self.sdk = make_fake_sdk(Path(self._directory.name))

    def tearDown(self) -> None:
        self._directory.cleanup()

    def test_found_and_missing_symbols(self) -> None:
        symbols = [
            sdk_api_check.Symbol("navigationBarMinimization", "navigation", "iOS 27.0"),
            sdk_api_check.Symbol("visibilityPriority", "bars", "iOS 27"),
            sdk_api_check.Symbol("axisBehavior", "bars", "iOS 27.1"),
        ]
        rows = {row["symbol"]: row for row in sdk_api_check.check(self.sdk, symbols)["symbols"]}
        self.assertTrue(rows["navigationBarMinimization"]["found"])
        self.assertEqual(rows["navigationBarMinimization"]["frameworks"], ["UIKit"])
        self.assertFalse(rows["axisBehavior"]["found"], "only the preferred interface is read")
        self.assertTrue(rows["visibilityPriority"]["found"])

    def test_declaration_skips_documentation_lines(self) -> None:
        symbols = [sdk_api_check.Symbol("navigationBarMinimization", "navigation", "iOS 27.0")]
        row = sdk_api_check.check(self.sdk, symbols)["symbols"][0]
        self.assertTrue(row["declaration"]["line"].startswith("@property"))
        self.assertEqual(row["declaration"]["availability"], "API_AVAILABLE(ios(27.0)")

    def test_swift_availability_from_previous_line(self) -> None:
        symbols = [sdk_api_check.Symbol("visibilityPriority", "bars", "iOS 27")]
        row = sdk_api_check.check(self.sdk, symbols)["symbols"][0]
        self.assertEqual(row["declaration"]["availability"], "@available(iOS 27.0, *)")

    def test_command_line_json(self) -> None:
        buffer = io.StringIO()
        with redirect_stdout(buffer):
            status = sdk_api_check.main(["--sdk", str(self.sdk), "--symbol", "axisBehavior", "--format", "json"])
        report = json.loads(buffer.getvalue())
        self.assertEqual(status, 0)
        self.assertEqual(report["symbols"][0]["symbol"], "axisBehavior")
        self.assertFalse(report["symbols"][0]["found"])

    def test_markdown_warns_about_missing_symbols(self) -> None:
        buffer = io.StringIO()
        with redirect_stdout(buffer):
            sdk_api_check.main(["--sdk", str(self.sdk), "--symbol", "axisBehavior"])
        self.assertIn("Do not write code against them", buffer.getvalue())

    def test_default_symbols_are_unique(self) -> None:
        names = [symbol.name for symbol in sdk_api_check.DEFAULT_SYMBOLS]
        self.assertEqual(len(names), len(set(names)))


if __name__ == "__main__":
    unittest.main()
