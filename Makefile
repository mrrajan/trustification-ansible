lint:
	ansible-lint
	antsibull-docs lint-collection-docs --plugin-docs --skip-rstcheck .

galaxy-importer-test:
	ansible-galaxy collection build --force
	python -m galaxy_importer.main redhat-trusted_profile_analyzer-*.tar.gz

role-readme: galaxy.yml roles/tpa_single_node/README.j2 roles/tpa_single_node/meta/argument_specs.yml roles/tpa_single_node/meta/main.yml
	# Trying to put aar_doc in testing-requirements.txt leads to dependency hell,
	# but if we install it in with other tools from testing-requirements.txt, it works fine
	if ! pip list 2>/dev/null | grep aar_doc > /dev/null; then \
		pip install -r testing-requirements.txt; \
		pip install aar_doc typer --no-deps; \
	fi
	aar_doc --output-template roles/tpa_single_node/README.j2 --output-mode replace roles/tpa_single_node/ markdown