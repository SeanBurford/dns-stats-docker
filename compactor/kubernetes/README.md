# dns-stats compactor Kubernetes config

Sample deployment.yaml:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nsd
  namespace: nsd-dev
  labels:
    app: nsd
spec:
...
  template:
...
    containers:
...
    - name: compactor
        image: seanburford/dns-stats-compactor:1.2.0
        imagePullPolicy: Always
        resources:
          requests:
            cpu: 10m
            memory: 32M
          limits:
            cpu: 100m
            memory: 64M
        livenessProbe:
          exec:
            command:
            - "pgrep"
            - "compactor"
          initialDelaySeconds: 10
          periodSeconds: 10
          timeoutSeconds: 5
        readinessProbe:
          exec:
            command:
            - "["
            - "-S"
            - "/var/dnstap/dnstap.sock"
            - "]"
          initialDelaySeconds: 5
          timeoutSeconds: 5
        volumeMounts:
        - name: dns-stats-config
          mountPath: /etc/dns-stats-compactor
        - name: dns-cache
          mountPath: /var/dnstap
        - name: dns-log
          mountPath: /var/log/dnstap
      volumes:
      - name: dns-stats-config
        configMap:
          name: dns-stats-config
      - name: dns-log
        nfs:  
          server: ...
          path: /srv/nfs/dnslog
      - name: dns-cache
        emptyDir: {}
```
