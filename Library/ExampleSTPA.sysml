package PaperExample {
    private import LibrarySTPA::DefineAnalysisPurpose::*;
    private import LibrarySTPA::ModelControlStructure::*;
    private import LibrarySTPA::IdentifyUCAs::*;
    private import LibrarySTPA::IdentifyLSs::*;
    private import LibrarySTPA::MetaTypesSTPA::*;
    private import LibrarySTPA::ViewsAndViewpoints::DefineAnalysisPurposeViews::*;
    package DefineAnalysisPurpose {
        package Stakeholders {
            concern Safety {
                subject Ushift;
                stakeholder Passenger;
                stakeholder Manufacturer;
                stakeholder Operator;
            }
            concern Reputation {
                subject Ushift;
                stakeholder Manufacturer;
                stakeholder Operator;
            }
            concern Revenue {
                subject Ushift;
                stakeholder Manufacturer;
                stakeholder Operator;
            }
        }
        package Losses {
            #loss part LossOfCustomerSatisfaction {
                :>> stakeholderConcern = Stakeholders::Reputation;
            }
            #loss part DamageToInfrastructure {
                :>> stakeholderConcern = Stakeholders::Revenue;
            }
            #loss part LossOfLife {
                :>> stakeholderConcern = Stakeholders::Safety;
            }
        }
        package Hazards {
            #hazard part VehicleCanNotExecuteMission {
                :>> lossesRef = Losses::LossOfCustomerSatisfaction;
            }
            #hazard part VehicleComesToCloseToInfrastructure {
                :>> lossesRef = Losses::DamageToInfrastructure;
            }
            #hazard part VehicleComesTocloseToPeople {
                :>> lossesRef = Losses::LossOfLife;
            }
        }
    }
    package ModelControlStructure {
        package Interactions {
            #controlAction item OperationCommand;
            #controlAction item ManeuverCMD;
            #controlAction item BrakingForce;
            #controlAction item SteeringForce;
            #controlAction item IntentionToTravel;
            #controlAction item IntentionToLeave;
            #controlAction item EmergencyCall;
            #feedback item VehiclePosition;
            #feedback item Acceleration;
            #feedback item VehicleStatus;
            #feedback item RoadIntegrity;
            #feedback item RoadSigns;
            #feedback item PositionVRUs;
            #feedback item PositionOtherTraffic;
        }
        package Structure {
            private import Interactions::*;
            #controlStructure part UshiftCS {
                :>> controllersRef = (Ushift.ControlElectronics, Teleoperator, Passenger, OtherTraffic, VRUs, Environment);
                :>> actuatorsRef = Ushift.DriveSystem;
                :>> sensorsRef = Ushift.PerceptionSystem;
                :>> processesRef = VehicleMovement;
                :>> controlActionsRef = (OperationCommand, ManeuverCMD, BrakingForce, SteeringForce, IntentionToTravel, IntentionToLeave, EmergencyCall);
                :>> feedbacksRef = (VehiclePosition, Acceleration, VehicleStatus, RoadIntegrity, RoadSigns, PositionVRUs, PositionOtherTraffic);
                #controller part Ushift {
                    #controller part ControlElectronics {
                        :>> processBeliefs = (VehicleLimitations, OperationalMode, UnderstandingOfPassengerBehavior, AssumptionAboutRoadInfrastructure,
                                              PassengerCapacity);

                        #processModel part VehicleLimitations;
                        #processModel part OperationalMode;
                        #processModel part UnderstandingOfPassengerBehavior;
                        #processModel part AssumptionAboutRoadInfrastructure;
                        #processModel part PassengerCapacity;
                    }
                    #sensor part PerceptionSystem;
                    #actuator part DriveSystem;
                }
                #controllerHuman part Teleoperator {
                    :>> mentalBeliefs = CurrentWorkload;
                    #mentalModel part CurrentWorkload;
                }
                #controllerHuman part Passenger {
                    :>> mentalBeliefs = UnderstandingOfVehicleBehavior;
                    #mentalModel part UnderstandingOfVehicleBehavior;
                }
                #controller part OtherTraffic;
                #controller part VRUs;
                #controller part Environment;
                #process part VehicleMovement;
            }
            flow of OperationCommand : ControlAction from UshiftCS.Teleoperator to UshiftCS.Ushift.ControlElectronics;
            flow of VehicleStatus : Feedback from UshiftCS.Ushift.ControlElectronics to UshiftCS.Teleoperator;
            flow of ManeuverCMD : ControlAction from UshiftCS.Ushift.ControlElectronics to UshiftCS.Ushift.DriveSystem;
            flow of BrakingForce : ControlAction from UshiftCS.Ushift.DriveSystem to UshiftCS.VehicleMovement;
            flow of SteeringForce : ControlAction from UshiftCS.Ushift.DriveSystem to UshiftCS.VehicleMovement;
            flow of Acceleration : ControlAction from UshiftCS.VehicleMovement to UshiftCS.Ushift.PerceptionSystem;
            flow of RoadIntegrity : Feedback from UshiftCS.Environment to UshiftCS.Ushift.PerceptionSystem;
            flow of RoadSigns : Feedback from UshiftCS.Environment to UshiftCS.Ushift.PerceptionSystem;
            flow of PositionVRUs : Feedback from UshiftCS.VRUs to UshiftCS.Ushift.PerceptionSystem;
            flow of PositionOtherTraffic : Feedback from UshiftCS.OtherTraffic to UshiftCS.Ushift.PerceptionSystem;
            flow of VehiclePosition : Feedback from UshiftCS.Ushift.PerceptionSystem to UshiftCS.Ushift.ControlElectronics;
            flow of PositionVRUs : Feedback from UshiftCS.Ushift.PerceptionSystem to UshiftCS.Ushift.ControlElectronics;
            flow of RoadIntegrity : Feedback from UshiftCS.Ushift.PerceptionSystem to UshiftCS.Ushift.ControlElectronics;
            flow of PositionOtherTraffic : Feedback from UshiftCS.Ushift.PerceptionSystem to UshiftCS.Ushift.ControlElectronics;
            flow of RoadSigns : Feedback from UshiftCS.Ushift.PerceptionSystem to UshiftCS.Ushift.ControlElectronics;
            flow of IntentionToTravel : ControlAction from UshiftCS.Passenger to UshiftCS.Ushift.ControlElectronics;
            flow of IntentionToLeave : ControlAction from UshiftCS.Passenger to UshiftCS.Ushift.ControlElectronics;
            flow of EmergencyCall : ControlAction from UshiftCS.Passenger to UshiftCS.Ushift.ControlElectronics;
        }
    }
    package IdentifyUCAs {
        package Contexts {
            #context part EmergencyStateDueToClosedOneWayStreet {
                :>> systemConditions = EmergencyState;
                :>> environmentalConditions = ClosedOneWayStreet;
            }
            #sysCon part EmergencyState;
            #envCon part ClosedOneWayStreet;
        }
        package UCAs {
            #uca item TeleoperatorDoesNotProvideOperationCommand {
                doc /* Teleoperator does not provide operation command when the automated vehicle is in an emergency situation */
                :>> sourceRef = ModelControlStructure::Structure::UshiftCS.Teleoperator;
                :>> controlActionRef = ModelControlStructure::Interactions::OperationCommand;
                :>> typeRef = typesOfCAs.NotProvided;
                :>> receiverRef = ModelControlStructure::Structure::UshiftCS.Ushift.ControlElectronics;
                :>> contextRef = Contexts::EmergencyStateDueToClosedOneWayStreet;
                :>> hazardsRef = DefineAnalysisPurpose::Hazards::VehicleCanNotExecuteMission;
            }
        }
    }
    package IdentifyLSs {
        package CausalFactors {
            #cf part TeleoperatorNotInformed {
                :>> factorRef = ModelControlStructure::Interactions::VehicleStatus;
                :>> status = "not forwarded";
            }
        }
        package LossScenarios {
            #ls part TeleoperatorNotAwareOfVehiclesEmergencySituation {
                doc /* The automated vehicle drives into a one way street which is closed and can not resolve the situation. However, the teleoperator is not aware that he is responsible for the vehicle. As a result, the teleoperator does not provide a resolving operation command */
                :>> causalFactorsRef = CausalFactors::TeleoperatorNotInformed;
                :>> ucasRef = IdentifyUCAs::UCAs::TeleoperatorDoesNotProvideOperationCommand;
            }
        }
    }
    package Views {
        private import CameoViewsSTPA::**;
        view ShowLosses : DefineLosses::LossTree {
            expose DefineAnalysisPurpose::Losses::*;
        }
        view HazardsAndLosses : HazardsTable {
            expose PaperExample::DefineAnalysisPurpose::**;
            filter @hazard;
        }
        view UCAs : UCAsTable {
            expose PaperExample::IdentifyUCAs::**;
            filter @uca;
        }
        view LSs : LSsTable {
            expose PaperExample::IdentifyLSs::**;
            filter @ls;
        }
    }
}