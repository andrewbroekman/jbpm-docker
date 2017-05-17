# Docker container for jBPM Workbench

To run the container:

```bash
docker run -t -d  \
  -e KC_REALM={name of the Keycloak Realm} \
  -e KC_BASE_URL={Base URL of your keycloak install. Usually ends with /auth \
  -e KC_KIE_SECRET={This is the secret for the kie Keycloak client} \
  -e KC_KIE_GIT_SECRET={This is the secret for the kie-git Keycloak client} \
  -e KC_KIE_EXECUTION_SERVER_SECRET={This is the secret for the kie-execution-server Keycloak client} \
  -e MYSQL_DATABASE={MySQL database name} \
  -e MYSQL_PASSWORD={MySQL database password} \
  -e MYSQL_USERNAME={MySQL database user} \
  -e MYSQL_PORT_3306_TCP_ADDR={MySQL Database host} \
  -e MYSQL_PORT_3306_TCP_PORT={MySQL Database port} \
  -e KIE_SERVER_USER={Name of a Keycloak user with kie-server role. Usually called kieserver} \
  -e KIE_SERVER_PWD={password for the aforementioned user} \
  -e KIE_SERVER_CONTROLLER_USER={use the same user as before} \
  -e KIE_SERVER_CONTROLLER_PWD={use the same password as before} \
  -p 8080:8080 -p 8001:8001
  lorissantamaria/jbpm
```
