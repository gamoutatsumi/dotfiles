#!/usr/bin/env bash

exec deno --unstable run --allow-net --allow-run --allow-env --allow-read ./deploy.ts $@
