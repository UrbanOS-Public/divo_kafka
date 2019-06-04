defmodule DivoKafkaTest do
  use ExUnit.Case

  @zookeeper %{
    zookeeper: %{
      image: "wurstmeister/zookeeper:latest",
      ports: ["2181:2181"],
      healthcheck: %{
        test: ["CMD-SHELL", "echo ruok | nc -w 2 zookeeper 2181"],
        interval: "5s",
        timeout: "10s",
        retries: 3
      }
    }
  }

  describe "produces a kafka stack map" do
    test "produces a kafka stack map with no specified environment variables" do
      expected =
        %{
          kafka: %{
            image: "wurstmeister/kafka:latest",
            ports: ["9092:9092"],
            environment: [
              "KAFKA_AUTO_CREATE_TOPICS_ENABLE=true",
              "KAFKA_ADVERTISED_LISTENERS=INSIDE://:9094,OUTSIDE://localhost:9092",
              "KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=INSIDE:PLAINTEXT,OUTSIDE:PLAINTEXT",
              "KAFKA_LISTENERS=INSIDE://:9094,OUTSIDE://:9092",
              "KAFKA_INTER_BROKER_LISTENER_NAME=INSIDE",
              "KAFKA_CREATE_TOPICS=clusterready:1:1",
              "KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181"
            ],
            depends_on: ["zookeeper"],
            healthcheck: %{
              test: ["CMD-SHELL", "kafka-topics.sh --zookeeper zookeeper:2181 --list | grep clusterready || exit 1"],
              interval: "10s",
              timeout: "20s",
              retries: 3
            }
          }
        }
        |> Map.merge(@zookeeper)

      actual = DivoKafka.gen_stack([])

      assert actual == expected
    end

    test "produces a kafka stack map with supplied environment config" do
      expected =
        %{
          kafka: %{
            image: "wurstmeister/kafka:latest",
            ports: ["9092:9092"],
            environment: [
              "KAFKA_AUTO_CREATE_TOPICS_ENABLE=true",
              "KAFKA_ADVERTISED_LISTENERS=INSIDE://:9094,OUTSIDE://ci-host:9092",
              "KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=INSIDE:PLAINTEXT,OUTSIDE:PLAINTEXT",
              "KAFKA_LISTENERS=INSIDE://:9094,OUTSIDE://:9092",
              "KAFKA_INTER_BROKER_LISTENER_NAME=INSIDE",
              "KAFKA_CREATE_TOPICS=streaming-data:1:1",
              "KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181"
            ],
            depends_on: ["zookeeper"],
            healthcheck: %{
              test: ["CMD-SHELL", "kafka-topics.sh --zookeeper zookeeper:2181 --list | grep streaming-data || exit 1"],
              interval: "10s",
              timeout: "20s",
              retries: 3
            }
          }
        }
        |> Map.merge(@zookeeper)

      actual = DivoKafka.gen_stack(auto_topic: true, outside_host: "ci-host", create_topics: "streaming-data:1:1")

      assert actual == expected
    end
  end
end
