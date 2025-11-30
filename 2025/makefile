.PHONY: gen spec

gen:
	@test -n "$(day)" || (echo "Error: day variable is required. Usage: make gen day=1" && exit 1)
	@mkdir -p spec src resources
	@sed -e 's/ZPDAY/$(shell printf "%02d" $(day))/g' -e 's/DAY/$(day)/g' template_spec.cr > spec/day_$(shell printf "%02d" $(day))_spec.cr
	@sed -e 's/ZPDAY/$(shell printf "%02d" $(day))/g' -e 's/DAY/$(day)/g' template.cr > src/day_$(shell printf "%02d" $(day)).cr
	@echo "Generated files for day $(day):"
	@echo "  spec/day_$(shell printf "%02d" $(day))_spec.cr"
	@echo "  src/day_$(shell printf "%02d" $(day)).cr"

spec:
ifdef day
	@crystal spec --tag "~skip" spec/day_$(shell printf "%02d" $(day))_spec.cr
else
	@crystal spec --tag "~skip"
endif
