{{/*
=========================================================
 GATEWAY PROVIDER
=========================================================
Returns: "traefik", "kong"
---------------------------------------------------------
*/}}
{{/* HTTP Listener Name */}}
{{- define "gw.httpListenerName" }}
{{- if .Values.gateway.traefik.enabled }}web
{{- else }}{{ .Values.gateway.httpListener | default "http" }}
{{- end }}
{{- end }}
{{/* HTTPS Listener Name */}}
{{- define "gw.httpsListenerName" }}
{{- if .Values.gateway.traefik.enabled }}websecure
{{- else }}
{{- .Values.gateway.httpsListener | default "https" }}
{{- end }}
{{- end }}

{{/* HTTP Listener Port */}}
{{- define "gw.httpListenerPort" }}
{{- if .Values.gateway.traefik.enabled }}8000
{{- else }}
{{- .Values.gateway.httpListenerPort | default 80 }}
{{- end }}
{{- end }}
{{/* HTTPS Listener Port */}}
{{- define "gw.httpsListenerPort" }}
{{- if .Values.gateway.traefik.enabled }}8443
{{- else }}
{{- .Values.gateway.httpsListenerPort | default 443 }}
{{- end }}
{{- end }}
{{/*
=========================================================
 HTTPRoute
=========================================================
*/}}
{{- define "httpRoute.buildFilters" }}
{{- $name := .Values.deployment.name }}
{{- .Values.gateway.rules | toYaml }}
  filters:
{{- /* CORS Middleware */}}
{{- if and .Values.gateway.traefik.enabled .Values.gateway.cors.enabled }}
    - type: ExtensionRef
      extensionRef:
        group: traefik.io
        kind: Middleware
        name: {{ printf "%s-cors" $name }}
{{- end -}}
{{/* Custom Headers */}}
{{- if .Values.gateway.customHeaders }}
{{- /* Traefik middleware custom header*/}}
    - type: ExtensionRef
      extensionRef:
        group: traefik.io
        kind: Middleware
        name: {{ printf "%s-custom-headers" $name }}
{{- end -}}
{{- if and .Values.gateway.traefik.enabled .Values.gateway.s3Behavior.enabled }}
{{- /* Traefik middleware S3 Behavior */}}
{{- if and .Values.gateway.traefik.enabled .Values.gateway.s3Behavior.spa.enabled }}
    - type: ExtensionRef
      extensionRef:
        group: traefik.io
        kind: Middleware
        name: {{ printf "%s-spa-root" .Values.deployment.name }}
    - type: ExtensionRef
      extensionRef:
        group: traefik.io
        kind: Middleware
        name: {{ printf "%s-spa-errors" .Values.deployment.name }}
{{- end }}
    - type: ExtensionRef
      extensionRef:
        group: traefik.io
        kind: Middleware
        name: {{ .Values.deployment.name }}-bucket-rewrite
{{- end }}
{{- end -}}

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
