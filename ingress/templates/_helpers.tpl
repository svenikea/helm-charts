{{/*
Escape dots in a domain string (e.g. example.com -> example\.com)
Usage: {{ include "escapeDots" "example.com" }}
*/}}
{{- define "escapeDots" -}}
{{- replace "." "\\." . -}}
{{- end -}}
