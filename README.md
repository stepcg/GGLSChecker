# GGLSChecker

A simple Bash script to test whether a domain is being blocked by GoGuardian DNS filtering.

This tool resolves a given FQDN using the specified GoGuardian DNS servers and performs a direct HTTPS request to the resolved IP(s). It inspects the returned content for signs of blocking (e.g., "Blocked", "Restricted").

---

## How It Works

1. Prompts the user for:
   - Primary GoGuardian/LS DNS server
   - Secondary GoGuardian/LS DNS server (fallback)
   - The domain (FQDN) to test

2. Uses `dig` to resolve the FQDN with the provided DNS server(s).

3. For each returned IP, uses `curl` with `--resolve` and `-k` to send an HTTPS request.

4. Parses the response content for known GoGuardian block page keywords:
   - `Blocked`
   - `Restricted`
   - `This website has been blocked`

5. Outputs either ✅ **Allowed** or ❌ **Blocked**

---

## Usage

### Prerequisites

- Bash shell (default on macOS and Linux)
- `dig` and `curl` installed

### Run the Script

```bash
chmod +x GGLSChecker.sh
./GGLSChecker.sh
