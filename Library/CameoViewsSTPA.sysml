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
            view Documentation : CoreViews::ColumnByExpressionView :> column {
                attribute :>> isMultiline default true;
                render rendering : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in rowElement : Element;
                        (rowElement.ownedElement as Comment).body
                    }
                }
            }
            view ContextRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement;
                        (getRef(rowElement, "contextRef") as Feature).declaredName
                    }
                }
            }
            view SourceRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement;
                        (getRef(rowElement, "sourceRef") as Feature).declaredName
                    }
                }
            }
            view ControlActionRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement;
                        (getRef(rowElement, "controlActionRef") as Feature).declaredName
                    }
                }
            }
            view TypeRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement;
                        (getRef(rowElement, "typeRef") as Feature).declaredName
                    }
                }
            }
            view ReceiverRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement;
                        (getRef(rowElement, "receiverRef") as Feature).declaredName
                    }
                }
            }
            view HazardsRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement;
                        (getRef(rowElement, "hazardsRef") as Feature).declaredName
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
            view Documentation : CoreViews::ColumnByExpressionView :> column {
                attribute :>> isMultiline default true;
                render rendering : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in rowElement : Element;
                        (rowElement.ownedElement as Comment).body
                    }
                }
            }
            view CausalFactorsRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement;
                        (getRef(rowElement, "causalFactorsRef") as Feature).declaredName
                    }
                }
            }
            view UCAsRef : CoreViews::ColumnByExpressionView :> column {
                render rendering asTableCell : CoreViews::StringCellRendering :>> asTableCell {
                    calc :>> getValue {
                        in :>> rowElement;
                        (getRef(rowElement, "ucasRef") as Feature).declaredName
                    }
                }
            }
        }
    }
}