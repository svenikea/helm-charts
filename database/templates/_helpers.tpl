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

{{- define "base64EncodeMap" -}}
{{- $result := dict -}}
{{- range $key, $value := . -}}
{{- $result = set $result $key (b64enc $value) -}}
{{- end -}}
{{- toYaml $result -}}
{{- end -}}
