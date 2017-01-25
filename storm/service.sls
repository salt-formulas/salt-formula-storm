{%- from "storm/map.jinja" import server with context %}

storm_nimbus_service:
  service.running:
  - name: storm-nimbus
  - enable: True
  - watch:
    - file: storm_config
    - file: storm_nimbus_service_script

storm_supervisor_service:
  service.running:
  - name: storm-supervisor
  - enable: True
  - watch:
    - file: storm_config
    - file: storm_supervisor_service_script
