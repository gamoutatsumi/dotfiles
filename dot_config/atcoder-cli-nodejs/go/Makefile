.PHONY: all
all: test submit

.PHONY: test
test:
	oj test -c "go run main.go" -d ./tests

.PHONY: submit
submit:
	npx acc submit
