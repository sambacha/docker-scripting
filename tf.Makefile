.PRECIOUS: output.json terraform.tfplan terraform.tfstate

output.json: terraform.tfstate
	terraform output -no-color -json | tee $@

plan: terraform.tfplan

terraform.tfplan:
	terraform plan -out $@

terraform.tfstate: terraform.tfplan
	terraform apply $^

apply: terraform.tfstate