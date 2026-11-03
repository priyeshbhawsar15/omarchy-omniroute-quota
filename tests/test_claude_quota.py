import importlib.machinery
import importlib.util
import pathlib
import unittest

HELPER = pathlib.Path(__file__).resolve().parents[1] / "bin" / "omniroute-quota"
loader = importlib.machinery.SourceFileLoader("omniroute_quota", str(HELPER))
spec = importlib.util.spec_from_loader("omniroute_quota", loader)
helper = importlib.util.module_from_spec(spec)
loader.exec_module(helper)

CONNECTION = {
    "provider": "claude",
    "isActive": True,
    "providerSpecificData": {"organizationType": "claude_pro"},
}


def window(remaining, kind, reset="2099-01-01T00:00:00.000Z"):
    return {
        "used": 100 - remaining,
        "total": 100,
        "remaining": remaining,
        "remainingPercentage": remaining,
        "resetAt": reset,
        "unlimited": False,
        "claudeQuota": {"kind": kind},
    }


class BuildClaudeTest(unittest.TestCase):
    def test_reads_session_and_weekly_windows(self):
        data = helper.build_claude(
            CONNECTION,
            {"quotas": {"session (5h)": window(94, "session"), "weekly (7d)": window(99, "weekly_all")}},
        )
        self.assertEqual(data["plan"], "Claude Pro")
        self.assertEqual(data["session"]["percent"], 94)
        self.assertEqual(data["session"]["status"], "active")
        self.assertTrue(data["session"]["text"].startswith("94% · "))
        self.assertEqual(data["weekly"]["percent"], 99)

    def test_model_scoped_weekly_window_does_not_replace_overall_weekly(self):
        data = helper.build_claude(
            CONNECTION,
            {
                "quotas": {
                    "weekly opus (7d)": window(5, "weekly_opus"),
                    "weekly (7d)": window(99, "weekly_all"),
                    "session (5h)": window(94, "session"),
                }
            },
        )
        self.assertEqual(data["weekly"]["percent"], 99)

    def test_finds_windows_by_key_when_kind_is_missing(self):
        session = window(40, "session")
        del session["claudeQuota"]
        weekly = window(70, "weekly_all")
        del weekly["claudeQuota"]
        data = helper.build_claude(CONNECTION, {"quotas": {"session (5h)": session, "weekly (7d)": weekly}})
        self.assertEqual(data["session"]["percent"], 40)
        self.assertEqual(data["weekly"]["percent"], 70)

    def test_exhausted_session_is_reported(self):
        data = helper.build_claude(
            CONNECTION,
            {"quotas": {"session (5h)": window(0, "session"), "weekly (7d)": window(50, "weekly_all")}},
        )
        self.assertEqual(data["session"]["status"], "exhausted")
        self.assertEqual(data["weekly"]["status"], "active")

    def test_missing_telemetry_stays_unavailable(self):
        for cache in (None, {"quotas": {}, "message": "Quota API unavailable"}):
            data = helper.build_claude(CONNECTION, cache)
            self.assertEqual(data["session"]["status"], "unavailable")
            self.assertEqual(data["weekly"]["status"], "unavailable")
            self.assertEqual(data["session"]["text"], "Data unavailable")

    def test_no_active_connection_is_disabled(self):
        data = helper.build_claude(None, None)
        self.assertEqual(data["session"]["status"], "disabled")
        self.assertEqual(data["weekly"]["status"], "disabled")

    def test_plan_falls_back_when_organization_type_is_absent(self):
        data = helper.build_claude({"provider": "claude", "isActive": True}, {"quotas": {}})
        self.assertEqual(data["plan"], "Unknown")


if __name__ == "__main__":
    unittest.main()
