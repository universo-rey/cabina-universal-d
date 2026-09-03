import unittest

from scripts.validators.github_actions_untrusted_input_validator import checkout_errors, run_blocks


class WorkflowInputValidatorTests(unittest.TestCase):
    def test_quoted_run_key_is_parsed(self):
        lines = ['      - "run" : |', '          echo "${{ inputs.name }}"']
        self.assertEqual(list(run_blocks(lines)), [(2, '          echo "${{ inputs.name }}"')])

    def test_quoted_uses_key_requires_direct_credential_child(self):
        lines = [
            '      - "uses" : actions/checkout@v4',
            '        "with":',
            '          sparse-checkout: |',
            '            persist-credentials: false',
        ]
        self.assertEqual(checkout_errors(lines), [1])

    def test_direct_quoted_persist_credentials_is_accepted(self):
        lines = [
            '      - "uses" : actions/checkout@v4',
            '        "with":',
            '          "persist-credentials": false',
        ]
        self.assertEqual(checkout_errors(lines), [])


if __name__ == "__main__":
    unittest.main()
