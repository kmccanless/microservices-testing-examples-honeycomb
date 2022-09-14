data "honeycombio_query_specification" "build_times_over_2_min" {
  calculation {
    op     = "HEATMAP"
    column = "duration_ms"
  }

  filter {
    column = "job.status"
    op     = "="
    value  = "success"
  }

  filter {
    column = "trace.parent_id"
    op     = "does-not-exist"
  }

  filter {
    column = "duration_ms"
    op = ">"
    value = var.ideal_build_duration
  }

  time_range = var.time_range
}

resource "honeycombio_query" "build_times_over_ideal" {
  dataset    = var.dataset
  query_json = data.honeycombio_query_specification.build_times_over_2_min.json
}

resource "honeycombio_query_annotation" "build_times_over_ideal_annotation" {
    dataset     = var.dataset
    query_id    = honeycombio_query.build_times_over_ideal.id
    name        = "Slow Builds?"
    description = "Explore builds that are taking longer than ideal - 2 minutes"
}