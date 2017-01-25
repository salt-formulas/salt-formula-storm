{%- from "storm/map.jinja" import server with context %}

storm_config:
  file.managed:
  - name: /opt/storm/conf/storm.yaml
  - source: salt://storm/files/storm.yaml
  - user: storm
  - group: storm
  - mode: 640
  - template: jinja
