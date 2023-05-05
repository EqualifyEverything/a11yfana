# Use the latest Ubuntu image
FROM ubuntu:latest

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y apt-transport-https software-properties-common wget systemd

# Add Grafana key and repository
RUN wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key && \
    echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | tee -a /etc/apt/sources.list.d/grafana.list

# Update package list and install Grafana
RUN apt-get update && \
    apt-get install -y grafana

# Copy custom configuration files
COPY ./grafana/grafana.ini /etc/grafana/grafana.ini
COPY ./grafana/ldap.toml /etc/grafana/ldap.toml
COPY ./grafana/provisioning /etc/grafana/provisioning

# Enable and start Grafana service
RUN systemctl enable grafana-server.service
CMD systemctl start grafana-server && sleep infinity

# Expose Grafana on port 3000
EXPOSE 3000
