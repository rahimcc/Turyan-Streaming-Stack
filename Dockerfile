# Extends the existing Debezium Connect image (matches your worker's
# version, 3.6.3.Final, from the earlier plugin list) with the
# ClickHouse JDBC driver added into the JDBC sink connector's own
# plugin directory — required because Kafka Connect's plugin
# isolation loads each connector's classpath independently; a driver
# placed anywhere else won't be visible to it.

FROM quay.io/debezium/connect:3.6

ARG CLICKHOUSE_JDBC_VERSION=0.6.3

USER root

# Debezium's Connect image includes curl already; if this errors,
# swap in `microdnf install -y curl` first.
RUN curl -fL -o /kafka/connect/debezium-connector-jdbc/clickhouse-jdbc-${CLICKHOUSE_JDBC_VERSION}-all.jar \
    https://github.com/ClickHouse/clickhouse-jdbc/releases/download/v${CLICKHOUSE_JDBC_VERSION}/clickhouse-jdbc-${CLICKHOUSE_JDBC_VERSION}-all.jar

# Debezium's images run as a non-root user (kafka, uid 1001) — restore
# that after the root-owned copy above, and make sure the new jar is
# actually readable by it.
RUN chown kafka:kafka /kafka/connect/debezium-connector-jdbc/clickhouse-jdbc-${CLICKHOUSE_JDBC_VERSION}-all.jar

USER 1001