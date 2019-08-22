defmodule DivoKafka do
  @moduledoc """
  Defines a simple kafka and zookeeper stack as a
  map compatible with divo for building a docker-compose
  file.
  """
  @behaviour Divo.Stack

  @doc """
  Implements the Divo Stack behaviour to take a
  keyword list of defined variables specific to
  the DivoKafka stack and returns a map describing the
  service definition of zookeeper and kafka.
  """
  @impl Divo.Stack
  @spec gen_stack([tuple()]) :: map()
  def gen_stack(envars) do
    topics = Keyword.get(envars, :create_topics, "clusterready:1:1")
    host = Keyword.get(envars, :outside_host, "localhost")
    auto_create_topics = Keyword.get(envars, :auto_topic, true)
    kafka_image_version = Keyword.get(envars, :kafka_image_version, "latest")

    check_topic =
      topics
      |> String.split(":")
      |> List.first()

    %{
      zookeeper: %{
        image: "wurstmeister/zookeeper:latest",
        ports: ["2181:2181"],
        healthcheck: %{
          test: ["CMD-SHELL", "echo ruok | nc -w 2 zookeeper 2181"],
          interval: "5s",
          timeout: "10s",
          retries: 3
        }
      },
      kafka: %{
        image: "wurstmeister/kafka:#{kafka_image_version}",
        ports: ["9092:9092"],
        environment: [
          "KAFKA_AUTO_CREATE_TOPICS_ENABLE=#{auto_create_topics}",
          "KAFKA_ADVERTISED_LISTENERS=INSIDE://:9094,OUTSIDE://#{host}:9092",
          "KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=INSIDE:PLAINTEXT,OUTSIDE:PLAINTEXT",
          "KAFKA_LISTENERS=INSIDE://:9094,OUTSIDE://:9092",
          "KAFKA_INTER_BROKER_LISTENER_NAME=INSIDE",
          "KAFKA_CREATE_TOPICS=#{topics}",
          "KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181"
        ],
        depends_on: ["zookeeper"],
        healthcheck: %{
          test: ["CMD-SHELL", "kafka-topics.sh --zookeeper zookeeper:2181 --list | grep #{check_topic} || exit 1"],
          interval: "10s",
          timeout: "20s",
          retries: 3
        }
      }
    }
  end
end
