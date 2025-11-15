{{/*
Escape dots in a domain string (e.g. example.com -> example\.com)
Usage: {{ include "escapeDots" "example.com" }}
*/}}
{{- define "escapeDots" -}}
{{- replace "." "\\." . -}}
{{- end -}}

{{/*
Return the host suffix (everything after the first label).
Coerces input to a string so it works whether .host is provided as a plain string
or as a single-element slice. Strips leading "*." and removes the left-most label
so:
  "s3.example.com"            -> "s3.example.com"
  "bucket.s3.example.com"     -> "s3.example.com"
  ["bucket.s3.example.com"]   -> "s3.example.com"
  "*.s3.example.com"          -> "s3.example.com"
Usage: include "s3.hostSuffix" (dict "host" .Values.ingress.hostName)
*/}}
{{- define "s3.hostSuffix" -}}
  {{- /* stringify the input */ -}}
  {{- $raw := printf "%v" .host -}}
  {{- /* remove leading wildcard and trim whitespace */ -}}
  {{- $h := trimPrefix "*." $raw | trim -}}
  {{- /* remove the first label (everything up to and including the first dot) */ -}}
  {{- $suffix := regexReplaceAll `^[^.]+\.` $h "" -}}
  {{- if eq $suffix "" -}}
    {{- print $h -}}
  {{- else -}}
    {{- print $suffix -}}
  {{- end -}}
{{- end -}}
