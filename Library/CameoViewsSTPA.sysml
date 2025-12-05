package CameoViewsSTPA {
    private import Metaobjects::*;
    private import KerML::*;
    private import SysML::*;
    private import DS_Views::*;
    private import LibrarySTPA::MetaTypesSTPA::*;
    calc getRef {
        in e : Element;
        in n : LiteralString;
        in r = getRefUsageMember(e, n);
        getRefOfFCE(r as FeatureChainExpression) ?? getRefOfOE(r as OperatorExpression) ?? getRefOfFRE(r as FeatureReferenceExpression)
    }
    calc getRefUsageMember {
        in e : Element;
        in n : LiteralString;
        ((e as Usage).ownedFeature->ControlFunctions::select {
            in e;
            (e as Element).name == n
        } as ReferenceUsage).ownedMember
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
        render rendering :>> asTable {
            view Hazard : CoreViews::ColumnByFeatureView :> column {
                ref item :>> columnFeature = featureTarget meta Feature;
            }
            view LossReference : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::ElementCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement;
                        getRef(rowElement, "lossesRef") as Metaobject
                    }
                }
            }
        }
    }
    view def UCAsTable :> CoreViews::bt, SymbolicViewsByExpression::NonStandardLibraryElementFilter {
        render rendering :>> asTable {
            view UCA : CoreViews::ColumnByFeatureView :> column {
                ref item :>> columnFeature = featureTarget meta Feature;
            }
            view ContextRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::ElementCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement;
                        getRef(rowElement, "contextRef") as Metaobject
                    }
                }
            }
            view SourceRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::ElementCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement;
                        getRef(rowElement, "sourceRef") as Metaobject
                    }
                }
            }
            view ControlActionRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::ElementCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement;
                        getRef(rowElement, "controlActionRef") as Metaobject
                    }
                }
            }
            view TypeRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::ElementCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement;
                        getRef(rowElement, "typeRef")
                    }
                }
            }
            view ReceiverRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::ElementCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement;
                        getRef(rowElement, "receiverRef") as Metaobject
                    }
                }
            }
            view HazardsRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::ElementCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement;
                        getRef(rowElement, "hazardsRef") as Metaobject
                    }
                }
            }
        }
    }
    view def LSsTable :> CoreViews::bt, SymbolicViewsByExpression::NonStandardLibraryElementFilter {
        render rendering :>> asTable {
            view LS : CoreViews::ColumnByFeatureView :> column {
                ref item :>> columnFeature = featureTarget meta Feature;
            }
            view CausalFactorsRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::ElementCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement;
                        getRef(rowElement, "causalFactorsRef") as Metaobject
                    }
                }
            }
            view UCAsRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::ElementCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement;
                        getRef(rowElement, "ucasRef") as Metaobject
                    }
                }
            }
        }
    }
}