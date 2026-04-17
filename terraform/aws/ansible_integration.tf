# ==========================================
# ANSIBLE INTEGRATION (THE BRIDGE)
# ==========================================

# Auto-generate the Ansible inventory file
resource "local_file" "ansible_inventory" {
  filename = "../../ansible/inventory.ini"
  content  = <<-EOT
[web]
${aws_instance.web_vm.public_ip}

[web:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_ed25519
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
  EOT
}

# Auto-generate the Ansible group_vars file
resource "local_file" "ansible_vars" {
  filename = "../../ansible/group_vars/web.yml"
  content  = <<-EOT
app_repo: "https://github.com/pravinmishraaws/theepicbook.git"
app_dest: "/home/ubuntu/theepicbook"
app_user: "ubuntu"

# Database Configuration
db_host: "${aws_db_instance.epicbook_db.address}"
db_user: "dbadmin"
db_password: "${var.db_password}"
db_name: "bookstore"
  EOT
}
