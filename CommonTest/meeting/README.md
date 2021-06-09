
```
ct_run:run_test([{suite, meeting_SUITE}]).
```

发现all_same_owner函数报错，这是因为触发了race condition。