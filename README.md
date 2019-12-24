# prometheus-exporter-sample

Sample to monitor go application's metrics

## Get go application's metrics

use `github.com/prometheus/client_golang`  


```bash
$ go run main.go
```

application publish metrics via 2112 port

```bash
$ curl localhost:2112/metrics
# HELP go_gc_duration_seconds A summary of the GC invocation durations.
# TYPE go_gc_duration_seconds summary
go_gc_duration_seconds{quantile="0"} 0
go_gc_duration_seconds{quantile="0.25"} 0
go_gc_duration_seconds{quantile="0.5"} 0
go_gc_duration_seconds{quantile="0.75"} 0
go_gc_duration_seconds{quantile="1"} 0
go_gc_duration_seconds_sum 0
go_gc_duration_seconds_count 0
# HELP go_goroutines Number of goroutines that currently exist.
# TYPE go_goroutines gauge
go_goroutines 7
# HELP go_info Information about the Go environment.
# TYPE go_info gauge
go_info{version="go1.12.5"} 1
# HELP go_memstats_alloc_bytes Number of bytes allocated and still in use.
# TYPE go_memstats_alloc_bytes gauge
go_memstats_alloc_bytes 338976
# HELP go_memstats_alloc_bytes_total Total number of bytes allocated, even if freed.
# TYPE go_memstats_alloc_bytes_total counter
go_memstats_alloc_bytes_total 338976
# HELP go_memstats_buck_hash_sys_bytes Number of bytes used by the profiling bucket hash table.
...
```

## Run application on kubernetes

```bash
docker build -t <image_path> .
docker push <image_path>
```

```bash
$ kubectl apply -f deployment.yml
```

## Prometheus collect metrics 

use `service discovery`

```yaml
scrape_configs:
- job_name: 'go-metrics'
  kubernetes_sd_configs:
  - role: endpoints
  relabel_configs:
  - source_labels:
    - __meta_kubernetes_namespace
    - __meta_kubernetes_service_name
    regex: default;sample-go-app-service
    action: keep
  - source_labels:
    - __meta_kubernetes_namespace
    - __meta_kubernetes_pod_container_port_number
    regex: default;2112
    action: keep
  - source_labels:
    - __meta_kubernetes_pod_name
    target_label: job
  - source_labels:
    - __meta_kubernetes_pod_name
    target_label: pod
```

* namespace : default
* service-name: sample-go-app-service
* container-port: 2112

## Grafana visualize metrics

following dashboard is good  
https://grafana.com/grafana/dashboards/6671

![image](https://user-images.githubusercontent.com/19891114/71416134-8bc93c00-26a2-11ea-813f-195ab8c1bdd7.png)
