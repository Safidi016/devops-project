<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>{{- escapeXML ( index . 0 ).Target }} - Trivy Report - {{ now }}</title>
  <style>
    body { font-family: Arial, Helvetica, sans-serif; }
    h1 { text-align: center; margin-bottom: 20px; }
    table { border-collapse: collapse; width: 90%; margin: 0 auto; }
    th, td { border: 1px solid #000; padding: 0.5em; text-align: left; }
    th { background-color: #f2f2f2; }
    .severity { font-weight: bold; text-align: center; color: #fff; }
    .severity-LOW { background-color: #5fbb31; }
    .severity-MEDIUM { background-color: #e9c600; }
    .severity-HIGH { background-color: #ff8800; }
    .severity-CRITICAL { background-color: #e40000; }
    .severity-UNKNOWN { background-color: #747474; }
    .group-header th { font-size: 1.2em; text-align: center; }
    .sub-header th { font-size: 1em; }
    a { color: #1a0dab; text-decoration: none; }
    a:hover { text-decoration: underline; }
  </style>
  
</head>
<body>
<h1>{{- escapeXML ( index . 0 ).Target }} - Trivy Security Report</h1>

{{- if . }}
  {{- range . }}
    <table>
      <tr class="group-header"><th colspan="6">{{ .Type | toString | escapeXML }}</th></tr>
      {{- if (eq (len .Vulnerabilities) 0) }}
        <tr><th colspan="6">No Vulnerabilities found</th></tr>
      {{- else }}
        <tr class="sub-header">
          <th>Package</th>
          <th>Vuln ID</th>
          <th>Severity</th>
          <th>Installed Version</th>
          <th>Fixed Version</th>
          <th>References</th>
        </tr>
        {{- range .Vulnerabilities }}
        <tr class="severity-{{ escapeXML .Vulnerability.Severity }}">
          <td>{{ escapeXML .PkgName }}</td>
          <td>{{ escapeXML .VulnerabilityID }}</td>
          <td class="severity">{{ escapeXML .Vulnerability.Severity }}</td>
          <td>{{ escapeXML .InstalledVersion }}</td>
          <td>{{ escapeXML .FixedVersion }}</td>
          <td>
            {{- range .Vulnerability.References }}
              <a href={{ escapeXML . | printf "%q" }}>{{ escapeXML . }}</a><br>
            {{- end }}
          </td>
        </tr>
        {{- end }}
      {{- end }}
    </table>
    <br>
  {{- end }}
{{- else }}
  <p>No data found in Trivy scan.</p>
{{- end }}

</body>
</html>
