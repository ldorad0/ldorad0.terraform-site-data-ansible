locals {
  site_data = jsondecode(base64decode(data.external.site_data.result["base64_encoded"]))
}

data "external" "site_data" {
  program = ["/bin/bash", "-c", <<-EOF
    printf '{"base64_encoded":"%s"}\n' $(
    ANSIBLE_NOCOLOR=true \
    ANSIBLE_TRANSFORM_INVALID_GROUP_CHARS=ignore \
    ANSIBLE_PYTHON_INTERPRETER=auto_silent \
    ANSIBLE_GATHERING=${var.ANSIBLE_GATHERING} \
    ansible -i "${var.inventory_file_path}" \
    ${var.inventory_hostname} -c local -m debug -a \
    msg='{{ hostvars[inventory_hostname] }}' | \
    tail -n +2 | \
    head -n -1 | \
    sed -e "s/\"msg\": {/{/" -e "s/    //" | \
    sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | \
    base64 -w 0
    )
    EOF
  ]
  query = {
  }  
}