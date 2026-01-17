<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Rapport Trivy</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    h1 { color: #2e6c80; }
    table { width: 100%; border-collapse: collapse; margin-top: 20px; }
    th, td { border: 1px solid #ddd; padding: 8px; }
    th { background-color: #f2f2f2; }
    tr:nth-child(even) { background-color: #f9f9f9; }
    tr:hover { background-color: #f1f1f1; }
  </style>
</head>
<body>
  <h1>Rapport de sécurité Trivy</h1>
  <table>
    <thead>
      <tr>
        <th>Nom du package</th>
        <th>Version</th>
        <th>Vulnérabilité</th>
        <th>Sévérité</th>
      </tr>
    </thead>
    <tbody>
      {{- range .Results }}
        {{- range .Vulnerabilities }}
        <tr>
          <td>{{ .PkgName }}</td>
          <td>{{ .InstalledVersion }}</td>
          <td>{{ .VulnerabilityID }}</td>
          <td>{{ .Severity }}</td>
        </tr>
        {{- end }}
      {{- end }}
    </tbody>
  </table>
</body>
</html>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Rapport Trivy</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    h1 { color: #2e6c80; }
    table { width: 100%; border-collapse: collapse; margin-top: 20px; }
    th, td { border: 1px solid #ddd; padding: 8px; }
    th { background-color: #f2f2f2; }
    tr:nth-child(even) { background-color: #f9f9f9; }
    tr:hover { background-color: #f1f1f1; }
  </style>
</head>
<body>
  <h1>Rapport de sécurité Trivy</h1>
  <table>
    <thead>
      <tr>
        <th>Nom du package</th>
        <th>Version</th>
        <th>Vulnérabilité</th>
        <th>Sévérité</th>
      </tr>
    </thead>
    <tbody>
      {{- range .Results }}
        {{- range .Vulnerabilities }}
        <tr>
          <td>{{ .PkgName }}</td>
          <td>{{ .InstalledVersion }}</td>
          <td>{{ .VulnerabilityID }}</td>
          <td>{{ .Severity }}</td>
        </tr>
        {{- end }}
      {{- end }}
    </tbody>
  </table>
</body>
</html>
