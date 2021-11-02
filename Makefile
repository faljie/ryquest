##
# Simplify docker usage
#
container = gem_ryquest
option = -ti --rm --user $(shell id -u):$(shell id -g) -v $(shell pwd):/app -e HOME=/app

.PHONY: doc
args = $(filter-out $@,$(MAKECMDGOALS))
%:
	@:

# build the docker image
install:
	@ docker build -t $(container) .

# run the test inside container
test:
	@ docker run ${option} ${container} rspec $(args)

# display linter error
lint:
	@ docker run $(option) ${container} rubocop ${args}

# documentation compilation
doc:
	@ docker run $(option) $(container) yardoc --list-undoc $(args)

# exec the commande in the container: make exec bash
exec:
	@ docker run $(option) $(container) $(args)

# remove everything created by makefile command
clean:
	- rm -rf doc
	- rm -rf coverage
	- rm -rf .bundle
	- rm -rf .yardoc
	- rm -rf .cache
	- rm -rf .local
	- rm .rspec_status
	- rm .byebug_history
	- rm .irb_history
	- rm .bash_history
	- docker image rm ruby:3.0.2
	- docker image rm $(container)
