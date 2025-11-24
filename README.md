# Vormetric Guard Point Test Script

## Overview

This Bash script automates the testing of Vormetric Data Security Manager (DSM) guard points by verifying their enable/disable functionality and encryption behavior. The script guides users through a comprehensive test procedure and logs all results.

## Prerequisites

- Vormetric Data Security Manager installed
- `vmd` command available in PATH
- Access to a configured guard point
- Bash shell environment

## Configuration

Edit the script variables at the top:

```bash
LOGFILE="guardpoint_test_log.txt"
GUARDPOINT="/path/to/your/guardpoint"  # Replace with actual guard point path
```

## Usage

1. Make the script executable:
```bash
chmod +x guardpoint_test.sh
```

2. Run the script:
```bash
./guardpoint_test.sh
```

## Test Procedure

The script performs the following test sequence:

1. **Initial Setup**
   - Prompts for Jira ticket number
   - Creates test description file with timestamp
   - Logs all actions to `guardpoint_test_log.txt`

2. **Enable Guard Point Test**
   - Waits for user to enable guard point via DSM
   - Continuously monitors guard point status
   - Verifies file displays clear text when guarded

3. **Disable Guard Point Test**
   - Waits for user to disable guard point
   - Monitors status until unguarded
   - Verifies file displays cipher text

4. **Re-enable Guard Point Test**
   - Repeats enable process
   - Final verification of clear text display

## Exit Codes

The script provides clear pass/fail status based on user input:
- **PASS**: All three verification steps confirmed (Y/Y/Y)
- **FAIL**: Any verification step failed or incomplete

## Output Files

- `guardpoint_test_log.txt`: Complete log of all operations and user responses
- `test_description.txt`: Test metadata file used for encryption verification

## Troubleshooting

- Ensure `vmd` command is accessible and properly configured
- Verify guard point path exists and is accessible
- Check DSM connectivity and permissions
- Review log file for detailed error information

## Notes

- The script includes 5-second polling intervals for status checks
- All user interactions are logged for audit purposes
- Manual DSM operations are required between test phases
