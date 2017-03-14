{%- from "storm/map.jinja" import server with context %}

group_storm:
  group.present:
  - name: storm
  - system: True

user_storm:
  user.present:
  - name: storm
  - shell: /bin/false
  - home: {{ server.prefix }}/storm
  - system: True
  - createhome: False
  - groups:
    - storm
  - require:
    - group: group_storm

download_storm_tarball:
  file.managed:
  - name: {{ server.tarball_file }}
  - source: {{ server.source }}
  - source_hash: {{ server.source_hash }}
  - user: root
  - group: root
  - mode: 644
  - unless: test -d {{ server.storm_real_home }} || test -f {{ server.tarball_file }}

unpack_storm_tarball:
  cmd.run:
  - name: tar zxf {{ server.tarball_file }}
  - cwd: {{ server.prefix }}
  - runas: root
  - onlyif: test -f {{ server.tarball_file }} && test ! -d {{ server.storm_real_home }}

permissions_storm_home:
  file.directory:
  - name: {{ server.storm_real_home }}
  - user: storm
  - group: storm
  - onlyif: test -d {{ server.storm_real_home }}
  - require:
    - user: user_storm

storm_local_dir:
  file.directory:
  - name: {{ server.storm_real_home }}/local
  - user: storm
  - group: storm
  - mode: 755
  - require:
    - file: permissions_storm_home

symlink_storm_home:
  file.symlink:
  - name: {{ server.prefix }}/storm
  - target: {{ server.storm_real_home }}
  - onlyif: test -d {{ server.storm_real_home }}

storm_nimbus_service_script:
  file.managed:
  - name: {{ server.init_dir }}/{{ server.storm_nimbus_service_script }}
  - source: salt://storm/files/{{ grains['init'] }}/{{ server.storm_nimbus_service_script }}
  - template: jinja
  - user: root
  - group: root
  - mode: 644

storm_supervisor_service_script:
  file.managed:
  - name: {{ server.init_dir }}/{{ server.storm_supervisor_service_script }}
  - source: salt://storm/files/{{ grains['init'] }}/{{ server.storm_supervisor_service_script }}
  - template: jinja
  - user: root
  - group: root
  - mode: 644

storm_ui_service_script:
  file.managed:
  - name: {{ server.init_dir }}/{{ server.storm_ui_service_script }}
  - source: salt://storm/files/{{ grains['init'] }}/{{ server.storm_ui_service_script }}
  - template: jinja
  - user: root
  - group: root
  - mode: 644
