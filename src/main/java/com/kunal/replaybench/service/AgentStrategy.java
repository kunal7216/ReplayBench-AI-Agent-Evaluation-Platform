package com.kunal.replaybench.service; import com.kunal.replaybench.model.Scenario; public interface AgentStrategy{ String type(); String decide(Scenario s); }
