{{/*
Print string from list split by ,
*/}}
{{- define "claimAccessMode" -}}
{{- range $idx, $val := $.Values.persistentVolumeClaim.claimAccessMode -}}
{{- if $idx }}
{{- print ", "  -}} 
{{- end -}}
{{- $val -}}
{{- end -}}
{{- end -}}

{{- define "extraClaimsAccessMode" -}}
{{- $accessModes := .claimAccessMode -}}
{{- range $idx, $val := $accessModes -}}
{{- if $idx }}{{- print ", " }}{{- end -}}
{{- $val -}}
{{- end -}}
{{- end -}}