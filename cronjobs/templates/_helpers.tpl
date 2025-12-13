{{- define "ssh-tunneling" -}}
apk add --no-cache openssh-client
ssh -o StrictHostKeyChecking=false \
  -i ~/.ssh/id_rsa \
{{- if .mysql }}
  -N -L 3306:127.0.0.1:3306
{{- end }}
{{- if .postgres }}
  -N -L 5432:127.0.0.1:5432
{{- end }} $SERVER_USER@$SERVER_IP &
TUNNEL_PID=$!
while [ ! -f /shared/done ]; do sleep 1; done;
kill $TUNNEL_PID && rm /shared/done
{{- end }}
