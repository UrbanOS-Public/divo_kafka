[![Master](https://travis-ci.org/smartcitiesdata/divo_kafka.svg?branch=master)](https://travis-ci.org/smartcitiesdata/divo_kafka)
[![Hex.pm Version](http://img.shields.io/hexpm/v/divo_kafka.svg?style=flat)](https://hex.pm/packages/divo_kafka)

# Divo Kafka

A library implementing the Divo Stack behaviour, providing a pre-configured Kafka
cluster via docker-compose for integration testing Elixir apps. The cluster is a
single-node kafka/zookeeper compose stack that can be configured with an arbitrary
list of topics to create on first start and the hostname/IP address the cluster
exposes to outside hosts.

Requires inclusion of the Divo library in your mix project.

## Installation

The package can be installed by adding `divo` and `divo_kafka` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:divo, "~> 1.1"},
    {:divo_kafka, "~> 0.1.6"}
  ]
end
```

## Use

In your Mix environment exs file (i.e. config/integration.exs), include the following:
```elixir
config :myapp,
  divo: [
    {DivoKafka, [create_topics: "my-data:1:1", outside_host: "ci-host"]}
  ]
```

In your integration test specify that you want to use Divo:
```elixir
use Divo
...
```

The resulting stack will create a single-node Kafka and Zookeeper instance with
Zookeeper exposing port 2181 to the host and Kafka exposing port 9092 to the host.

### Configuration

You may omit the configuration arguments to DivoKafka and still have a working stack.

* `create_topics`: A string of the form `topic1-name:1:1,topic2-name:1:1` which will ensure
the list of topics are created at first start of the cluster. Defaults to `clusterready:1:1`
to allow for readiness checking of the cluster.

* `outside_host`: The hostname or IP address by which hosts external to the Kafka cluster can
reach it (in this case, your app). Defaults to `localhost` but may cause problems when
running in a CI system, particularly a containerized one. In such circumstances, it is
recommended to use an address or name that is routable even if ExUnit will be running inside
a container.

* `auto_topic`: Whether or not topics will be created, if missing, when producing or consuming messages. Note that the topics supplied in `create_topics` will be created, on startup, regardless of this config setting. Defaults to `true`. 

* `kafka_image_version`: The kafka image ([wurstmeister/kafka](https://hub.docker.com/r/wurstmeister/kafka)) version to use. A list of available versions can be found on their [dockerhub tags page](https://hub.docker.com/r/wurstmeister/kafka/tags). Defaults to `false`

See [Divo GitHub](https://github.com/smartcitiesdata/divo) or [Divo Hex Documentation](https://hexdocs.pm/divo) for more instructions on using and configuring the Divo library.
See [wurstmeister/kafka](https://github.com/wurstmeister/kafka-docker) and
[wurstmeister/zookeeper](https://github.com/wurstmeister/zookeeper-docker) for further documentation
on using and configuring the features of these images.


## License
Released under [Apache 2 license](https://github.com/smartcitiesdata/divo_kafka/blob/master/LICENSE).
