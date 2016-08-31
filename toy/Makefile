SHELL := /bin/bash
RES_DIR := result
export OMP_NUM_THREADS := 1

ns := 200 500 1000 2000 
ks := 10 20 40 80 160
ss := $(shell seq -w -s' ' 1 10)
types := approx

.PHONY : all plot

.SECONDARY:

result_approx := \
	$(foreach s,$(ss),\
	$(foreach k,$(ks),\
	$(foreach type,$(types),\
	$(foreach n,$(ns),\
		result/$(n)_$(k)_$(s)_$(type).res))))

result_exact := \
	$(foreach s,$(ss),\
	$(foreach type,$(types),\
	$(foreach n,$(ns),\
		result/$(n)_$(n)_$(s)_$(type).res)))

ALL := $(result_approx) $(result_exact)

all: $(ALL)

result/%.res: $(RES_DIR)/
	n=$(word 1,$(subst _, ,$*));\
	m=$(word 2,$(subst _, ,$*));\
	s=$(word 3,$(subst _, ,$*));\
	type=$(word 4,$(subst _, ,$*));\
	python run.py $${n} $${m} $${s} $${type} | tail -n 1 > $@

$(RES_DIR)/:
	mkdir $@

### summarize result
SUM_ALL = $(RES_DIR)/sum.all.txt
$(SUM_ALL): $(ALL)
	cat $^ > $@

### plot figures
plot: toy_error.eps 

toy_%.eps: $(SUM_ALL)
	Rscript aggregate_result.R $^ $@ $*

