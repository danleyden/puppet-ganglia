define ganglia::data_source (
  $order = 10,
) {

  concat::fragment { "data_sources_start_$name":
    order   => $order,
    content => "\ndata_source \"$name\" ",
    target  => '/etc/ganglia/gmetad.conf',
  }

  Concat::Fragment <<| tag == "ganglia_data_source_$name" |>> {
    order  => $order + 1,
    target => '/etc/ganglia/gmetad.conf',
  }

  concat::fragment { "data_sources_end_$name":
    order   => ( $order + 2 ),
    content => "\n\n",
    target  => '/etc/ganglia/gmetad.conf',
  }

}
