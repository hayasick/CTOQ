SHELL := /bin/bash
BIN := octave
RES_DIR := result
export OMP_NUM_THREADS := 1

ns := 500 1000 2000 5000
ks := 20 40 80 160
ss := $(shell seq -w -s' ' 1 10)
methods := approx nystrom
datatypes := 2

.PHONY : all clean table

.SECONDARY:

result_approx := \
	$(foreach s,$(ss),\
	$(foreach k,$(ks),\
	$(foreach method,$(methods),\
	$(foreach data,$(datatypes),\
	$(foreach n,$(ns),\
		$(RES_DIR)/$(n)_$(k)_$(s)_$(method)_$(data).res)))))

result_exact := \
	$(foreach s,$(ss),\
	$(foreach method,approx,\
	$(foreach data,$(datatypes),\
	$(foreach n,$(ns),\
		$(RES_DIR)/$(n)_$(n)_$(s)_$(method)_$(data).res))))     

ALL := $(result_approx) $(result_exact)

all: $(ALL)

$(RES_DIR)/%.res: $(RES_DIR)/
	n=$(word 1,$(subst _, ,$*));\
	k=$(word 2,$(subst _, ,$*));\
	s=$(word 3,$(subst _, ,$*));\
	method=$(word 4,$(subst _, ,$*));\
	data=$(word 5,$(subst _, ,$*));\
	$(BIN) compare.m $${n} $${k} $${s} $${method} $${data} | tail -n 1 > $@

$(RES_DIR)/:
	mkdir $@

### summarize result
SUM_ALL = $(RES_DIR)/sum.all.txt
$(SUM_ALL): $(ALL)
	cat $^ > $@

### generate latex tables
table: kernel_error.tex kernel_time.tex 

kernel_%.tex: $(SUM_ALL)
	Rscript aggregate_result_as_table.R $^ $* | tail -n +5 | head -n -1 > $@


clean:
	rm $(RES_DIR)/*
	rm *.tex
