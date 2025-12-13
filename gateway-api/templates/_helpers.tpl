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
{{- end -}}
