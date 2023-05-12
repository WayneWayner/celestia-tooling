#Description

How to install a grafana dashboard for a celestia consensus node using prometheus and open it to the public.

#Requirements

- Celestia consensus node
- Grafana
- Prometheus

#Steps

##1. Install Prometheus & Grafana
There are tons of guides out there. Please use one of them to install Prometheus and Grafana.

##2. Tendermint Prometheus endpoint
Make sure your Prometheus endpoint is enabled. 

Open your config.toml (usually located at **.celestia-app/config/config.toml**) and ensure that prometheus is enabled and note the port of your prometheus endpoint.

```
# Check out the documentation for the list of available metrics.
prometheus = true

# Address to listen for Prometheus collector(s) connections
prometheus_listen_addr = ":26660"
```

##3. Enable public dashboards feature of Grafana
Open your **grafana.ini** and append the following to the end. This will allow you to share a dashboard with view only access with everyone.

```
[feature_toggles]
publicDashboards = true
```

##4. Setup Prometheus scraper

Add the celestia scrape job to your **prometheus.yml**

```
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ["localhost:9099"]
   

  - job_name: celestia
    static_configs:
      - targets: ['localhost:26660']
        labels:
          instance: validator    
```

##5. Setup Grafana
- Log in to your Grafana dashboard. If you use the default port **3000** you can open it in your firewall and login via **http://<yourNodeIP>:3000**
**user:admin pw:admin** is the default login which you should change to something more secure.

**Setup datasource**
- Navigate to http://<yourNodeIP>:3000
- Click this the gear icon to edit the configuration.
- Click on data sources
- Click Add new data source
- Choose Prometheus
- Enter URL (Default:http://localhost:9090)
- Hit save & test

**Import dashboard**
- Click the dashboard button (4 squares)
- Click on import
- Copy the content of celestia_dashboard.json into **Import via panel json**
- Hit load


##5. Make dashboard public

- Open the imported dashboard
- Click on the share button
- Choose Public dashboard
- Check at least "Enabled" in the Public dashboard configuration
- Copy the URL 
- Click on save public dashboard
- Replace localhost in your copied url with your public ip or domain

##6. Done