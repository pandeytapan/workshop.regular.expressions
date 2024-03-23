# Enable execution of all commands in a single shell for each recipe.
.ONESHELL:

ENV_PREFIX=$(shell python3 -c "if __import__('pathlib').Path('.venv/bin/pip').exists(): print('.venv/bin/')")

#Variables

# Define the virtual environment name.
VENV_NAME := .venv

# Specify the python and the pip binaries.
PYTHON := $(ENV_PREFIX)python3
PIP := $(ENV_PREFIX)pip

# Directories
CTAGS_DIR := ./

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = source
BUILDDIR      = build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile virtualenv install show-venv

# Target for creating the virtual environment.
virtualenv: ## Create a virtual environment and install dependencies.
	@echo "Creating virtualenv ..."
	@rm -rf $(VENV_NAME)
	@$(PYTHON) -m venv $(VENV_NAME)
	@$(PIP) install -U pip
	@echo "Virtual environment created."
	@make install

# Target for installing dependencies from requirements-base.txt.
install: ## Install base dependencies into the virtual environment.
	@echo "$(ENV_PREFIX)"
	@echo "Installing dependencies ..."
	@$(PIP) install -r requirements.txt
	@echo "Dependencies installed."
	@echo "!!!Activate the virtual environment by running: source $(VENV_NAME)/bin/activate"

# Target for showing the virtual environment.
show-venv: ## Show the virtual environment.
	@echo "Virtual environment: $(VENV_NAME)"
	@echo "Running using $(PYTHON) ..."
	@echo "Python Version" && $(PYTHON) --version
	@$(PYTHON) -m site

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
