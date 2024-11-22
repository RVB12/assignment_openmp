CC = g++
FLAGS = -O3 -DNDEBUG -DBOOST_UBLAS_NDEBUG


sources_exter = ../main.cpp


ifeq ($(prpcs_comp_lnk), true)
define rule_prpcs_cmpl_asmbl
$(subst .cpp,.o,$(1)): $(1)
	$(CC) -E -o $(subst .cpp,.i,$(1)) $(FLAGS) $(1)
	$(CC) -S -o $(subst .cpp,.s,$(1)) $(FLAGS) $(subst .cpp,.i,$(1))
	$(CC) -c -o $(subst .cpp,.o,$(1)) $(FLAGS) $(subst .cpp,.s,$(1))
endef
else
define rule_prpcs_cmpl_asmbl
$(subst .cpp,.o,$(1)): $(1)
	$(CC) -c -o $(subst .cpp,.o,$(1)) $(FLAGS) $(1)
endef
endif


$(program): $(sources_inter:.cpp=.o) $(sources_exter:.cpp=.o)
	$(CC) -o $@ $(FLAGS) $^

$(foreach source,$(sources_inter),$(eval $(call rule_prpcs_cmpl_asmbl,$(source))))

$(foreach source,$(sources_exter),$(eval $(call rule_prpcs_cmpl_asmbl,$(source))))


PHONY: clean
clean:
ifeq ($(prpcs_comp_lnk), true)
	-rm $(foreach ext,.i .s .o,$(subst .cpp,$(ext),$(sources_inter))) $(program)
else
	-rm $(subst .cpp,.o,$(sources_inter)) $(program)
endif
