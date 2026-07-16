package CameoViewsSTPA {
    private import Metaobjects::*;
    private import KerML::*;
    private import SysML::*;
    private import DS_Views::*;
    private import LibrarySTPA::MetaTypesSTPA::**;
    calc getRef {
        in e : Element;
        in n : LiteralString;
        in r = getUsageMember(e, n);
        getRefOfFCE(r as FeatureChainExpression) ?? getRefOfOE(r as OperatorExpression) ?? getRefOfFRE(r as FeatureReferenceExpression)
    }
    calc getUsageMember {
        in e : Element;
        in n : LiteralString;
        ((e as Usage).ownedFeature->ControlFunctions::select {
            in e;
            (e as Element).name == n
        } as Usage).ownedMember
    }
    calc getRefOfFCE {
        in e : FeatureChainExpression;
        if e.targetFeature istype Feature ? (e.targetFeature as Feature).featureTarget else e.targetFeature
    }
    calc getRefOfOE {
        in e : OperatorExpression;
        (e.argument as FeatureReferenceExpression).referent
    }
    calc getRefOfFRE {
        in e : FeatureReferenceExpression;
        e.referent
    }
    view def HazardsTable :> CoreViews::bt, SymbolicViewsByExpression::NonStandardLibraryElementFilter {
        render rendering HazardsTableRendering :>> asTable {
            view Hazard : CoreViews::ColumnByFeatureView :> column {
                ref item :>> columnFeature = featureTarget meta Feature;
            }
            view LossRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement : Element;
                        attribute elementName : LiteralString = "lossRef";
                        (getRef(rowElement, elementName) as Feature).declaredName
                    }
                }
            }
        }
        part customElementCreationDialog : DS_UIComponents::UIComponents::SysMLElementCreationDialog :>> creationDialog {
            attribute :>> actionName default "Create Hazard";
            part messageMenu :> itemCategories {
                part softReqItem : DS_UIComponents::CoreUIComponents::Dialogs::DialogItem :> abstractItems {
                    attribute :>> label default "hazard";
                    perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromTemplate :>> operation {
                        in ref = LibrarySTPA::MetaTypesSTPA::hazardExample meta Feature;
                    }
                }
            }
        }
    }
    view def UCAsTable :> CoreViews::bt, SymbolicViewsByExpression::NonStandardLibraryElementFilter {
        render rendering UCAsTableRendering :>> asTable {
            view UCA : CoreViews::ColumnByFeatureView :> column {
                ref item :>> columnFeature = featureTarget meta Feature;
            }
            view Documentation : CoreViews::ColumnByExpressionView :> column {
                attribute :>> isMultiline default true;
                render rendering : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in rowElement : Element;
                        (rowElement.ownedElement as KerML::Comment).body
                    }
                }
            }
            view ContextRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement : Element;
                        attribute elementName : LiteralString = "contextRef";
                        (getRef(rowElement, elementName) as Feature).declaredName
                    }
                }
            }
            view SourceRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement : Element;
                        attribute elementName : LiteralString = "sourceRef";
                        (getRef(rowElement, elementName) as Feature).declaredName
                    }
                }
            }
            view ControlActionRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement : Element;
                        attribute elementName : LiteralString = "controlActionRef";
                        (getRef(rowElement, elementName) as Feature).declaredName
                    }
                }
            }
            view TypeRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement : Element;
                        attribute elementName : LiteralString = "typeRef";
                        (getRef(rowElement, elementName) as Feature).declaredName
                    }
                }
            }
            view ReceiverRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement : Element;
                        attribute elementName : LiteralString = "receiverRef";
                        (getRef(rowElement, elementName) as Feature).declaredName
                    }
                }
            }
            view HazardsRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement : Element;
                        attribute elementName : LiteralString = "hazardsRef";
                        (getRef(rowElement, elementName) as Feature).declaredName
                    }
                }
            }
        }
        part customElementCreationDialog : DS_UIComponents::UIComponents::SysMLElementCreationDialog :>> creationDialog {
            attribute :>> actionName default "Create UCA";
            part messageMenu :> itemCategories {
                part softReqItem : DS_UIComponents::CoreUIComponents::Dialogs::DialogItem :> abstractItems {
                    attribute :>> label default "uca";
                    perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromTemplate :>> operation {
                        in ref = LibrarySTPA::MetaTypesSTPA::ucaExample meta Feature;
                    }
                }
            }
        }
    }
    view def LSsTable :> CoreViews::bt, SymbolicViewsByExpression::NonStandardLibraryElementFilter {
        render rendering LSsTableRendering :>> asTable {
            view LS : CoreViews::ColumnByFeatureView :> column {
                ref item :>> columnFeature = featureTarget meta Feature;
            }
            view Documentation : CoreViews::ColumnByExpressionView :> column {
                attribute :>> isMultiline default true;
                render rendering : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in rowElement : Element;
                        (rowElement.ownedElement as KerML::Comment).body
                    }
                }
            }
            view CausalFactorsRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement : Element;
                        attribute elementName : LiteralString = "causalFactorsRef";
                        (getRef(rowElement, elementName) as Feature).declaredName
                    }
                }
            }
            view UCAsRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement : Element;
                        attribute elementName : LiteralString = "ucasRef";
                        (getRef(rowElement, elementName) as Feature).declaredName
                    }
                }
            }
        }
        part customElementCreationDialog : DS_UIComponents::UIComponents::SysMLElementCreationDialog :>> creationDialog {
            attribute :>> actionName default "Create Loss Scenario";
            part messageMenu :> itemCategories {
                part softReqItem : DS_UIComponents::CoreUIComponents::Dialogs::DialogItem :> abstractItems {
                    attribute :>> label default "loss scenario";
                    perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromTemplate :>> operation {
                        in ref = LibrarySTPA::MetaTypesSTPA::lossScenarioExample meta Feature;
                    }
                }
            }
        }
    }
    package CustomViewsSTPA {
        private import DS_UIComponents::CoreUIComponents::Palette::*;
        private import LibrarySTPA::MetaTypesSTPA::*;
        view def 'STPA View' :> CoreViews::bsv {
            part :>> baseViewPalette {
                part :>> selectionCategory;
                part :>> toolsCategory;
                part :>> commonCategory;
                part specializationsCategory :> buttonCategories {
                    attribute :>> isCollapsed default true;
                    attribute :>> hasVisibleLabels default true;
                    attribute :>> label default "Specializations";
                    attribute :>> description default "Specializations";
                    part subclassificationButton : Button :> abstractButtons {
                        perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromCode :> operation {
                            in ref = ViewPalettes::CodeActionIdentifiers::subclassifactionAction;
                        }
                    }
                    part subsettingButton : Button :> abstractButtons {
                        perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromCode :> operation {
                            in ref = ViewPalettes::CodeActionIdentifiers::subsettingAction;
                        }
                    }
                }
                part STPA_Category :> buttonCategories {
                    attribute :>> isCollapsed default false;
                    attribute :>> hasVisibleLabels default true;
                    attribute :>> label default "STPA";
                    attribute :>> description default "STPA";
                    part purposeButtonMenu : ButtonsCategory :> abstractButtons {
                        part hazardButton : Button :> abstractButtons {
                            attribute :>> label = "hazard";
                            attribute :>> description = "hazard";
                            perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromTemplate :> operation { in ref = hazardExample.metadata; }
                        }
                        part lossButton : Button :> abstractButtons {
                            attribute :>> label = "loss";
                            attribute :>> description = "loss";
                            perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromTemplate :> operation { in ref = lossExample.metadata; }
                        }
                        part :>> focusedButton = lossButton;
                    }
                    part controllerButtonMenu : ButtonsCategory :> abstractButtons {
                        part controllerButton : Button :> abstractButtons {
                            attribute :>> label = "controller";
                            attribute :>> description = "controller";
                            perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromTemplate :> operation { in ref = controllerExample.metadata; }
                        }
                        part humanControllerButton : Button :> abstractButtons {
                            attribute :>> label = "human controller";
                            attribute :>> description = "human controller";
                            perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromTemplate :> operation { in ref = controllerHumanExample.metadata; }
                        }
                        part :>> focusedButton = controllerButton;
                    }
                    part loopButtonMenu : ButtonsCategory :> abstractButtons {
                        part processButton : Button :> abstractButtons {
                            attribute :>> label = "process";
                            attribute :>> description = "process";
                            perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromTemplate :> operation { in ref = processExample.metadata; }
                        }
                        part sensorButton : Button :> abstractButtons {
                            attribute :>> label = "sensor";
                            attribute :>> description = "sensor";
                            perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromTemplate :> operation { in ref = sensorExample.metadata; }
                        }
                        part actuatorButton : Button :> abstractButtons {
                            attribute :>> label = "actuator";
                            attribute :>> description = "actuator";
                            perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromTemplate :> operation { in ref = actuatorExample.metadata; }
                        }
                        part :>> focusedButton = processButton;
                    }
                    part beliefButtonMenu : ButtonsCategory :> abstractButtons {
                        part processModelButton : Button :> abstractButtons {
                            attribute :>> label = "process model";
                            attribute :>> description = "process model";
                            perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromTemplate :> operation { in ref = processModelExample.metadata; }
                        }
                        part mentalModelButton : Button :> abstractButtons {
                            attribute :>> label = "mental model";
                            attribute :>> description = "mental model";
                            perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromTemplate :> operation { in ref = mentalModelExample.metadata; }
                        }
                        part :>> focusedButton = processModelButton;
                    }
                    part interactionButtonMenu : ButtonsCategory :> abstractButtons {
                        part controlActionButton : Button :> abstractButtons {
                            attribute :>> label = "control action";
                            attribute :>> description = "control action";
                            perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromTemplate :> operation { in ref = controlActionExample.metadata; }
                        }
                        part feedbackButton : Button :> abstractButtons {
                            attribute :>> label = "feedback";
                            attribute :>> description = "feedback";
                            perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromTemplate :> operation { in ref = feedbackExample.metadata; }
                        }
                        part :>> focusedButton = controlActionButton;
                    }
                    part contextButtonMenu : ButtonsCategory :> abstractButtons {
                        part contextButton : Button :> abstractButtons {
                            attribute :>> label = "context";
                            attribute :>> description = "context";
                            perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromTemplate :> operation { in ref = contextExample.metadata; }
                        }
                        part envContextButton : Button :> abstractButtons {
                            attribute :>> label = "environmental context";
                            attribute :>> description = "environmental context";
                            perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromTemplate :> operation { in ref = envConExample.metadata; }
                        }
                        part sysContextButton : Button :> abstractButtons {
                            attribute :>> label = "system context";
                            attribute :>> description = "system context";
                            perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromTemplate :> operation { in ref = sysConExample.metadata; }
                        }
                        part :>> focusedButton = contextButton;
                    }
                    part analysisButtonMenu : ButtonsCategory :> abstractButtons {
                        part ucaButton : Button :> abstractButtons {
                            attribute :>> label = "unsafe control action";
                            attribute :>> description = "unsafe control action";
                            perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromTemplate :> operation { in ref = ucaExample.metadata; }
                        }
                        part lossScenarioButton : Button :> abstractButtons {
                            attribute :>> label = "loss scenario";
                            attribute :>> description = "loss scenario";
                            perform action : DS_UIComponents::CoreUIComponents::Operations::OperationFromTemplate :> operation { in ref = lossScenarioExample.metadata; }
                        }
                        part :>> focusedButton = ucaButton;
                    }
                }
            }
        }
    }
}