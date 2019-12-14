package org.camunda.bpm.link3

import org.camunda.bpm.application.ProcessApplication
import org.camunda.bpm.application.impl.ServletProcessApplication
import org.camunda.latera.bss.executionListeners.EventLogging
import org.camunda.latera.bss.executionListeners.AutoSaveOrderData
import org.camunda.latera.bss.logging.SimpleLogger
import org.camunda.bpm.engine.delegate.ExecutionListener
import org.camunda.bpm.engine.delegate.DelegateExecution

@ProcessApplication("pizza_order")
class PizzaOrderApplication extends ServletProcessApplication {
  ExecutionListener getExecutionListener() {
    return new ExecutionListener() {
      void notify(DelegateExecution execution) {
        new EventLogging().notify(execution)
        if (execution.getEventName().equals(ExecutionListener.EVENTNAME_START) && (execution.getCurrentActivityName() != null )) {
          new SimpleLogger(execution).info(
                  String.format(
                          "\n------------------------------------------------------------------------\n%s - %s",
                          execution.hasVariable("homsOrderCode") ? execution.getVariable("homsOrderCode") : execution.getProcessInstanceId(),
                          execution.getCurrentActivityName()))
        }
        if (execution.getEventName().equals(ExecutionListener.EVENTNAME_END)) {
          new AutoSaveOrderData().notify(execution)
        }
      }
    }
  }
}
