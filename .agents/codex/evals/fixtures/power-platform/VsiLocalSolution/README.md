# VsiLocalSolution Power Platform Fixture

Synthetic local-only Power Platform solution fixture for the VSI governed
Power Platform lane.

- Created with `pac solution init --publisher-name CabinaUniversal --publisher-prefix cabina`.
- Packed locally with `pac solution pack --zipfile .\out\VsiLocalSolution_unmanaged.zip --folder .\src --packagetype Unmanaged`.
- No tenant, environment, connector, Dataverse table, flow or production target
  was selected.
- No authentication token, connection reference, client secret or certificate
  was read, stored or printed.

The generated ZIP under `out/` is a local build output and is intentionally not
versioned.
