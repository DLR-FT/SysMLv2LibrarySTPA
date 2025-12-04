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
                concern :>> stakeholderConcern = Stakeholders::Reputation;
            }
            #loss part DamageToInfrastructure {
                concern :>> stakeholderConcern = Stakeholders::Revenue;
            }
            #loss part LossOfLife {
                concern :>> stakeholderConcern = Stakeholders::Safety;
            }
        }
        package Hazards {
            #hazard part VehicleCanNotExecuteMission {
                ref part:>> lossesRef = Losses::LossOfCustomerSatisfaction;
            }
            #hazard part VehicleComesToCloseToInfrastructure {
                ref part :>> lossesRef = Losses::DamageToInfrastructure;
            }
            #hazard part VehicleComesTocloseToPeople {
                ref part :>> lossesRef = Losses::LossOfLife;
            }
        }
    }
    
    package ModelControlStructure {
        package Interactions {
            // Control Actions
            #controlAction item OperationCommand;
            #controlAction item ManeuverCMD;
            #controlAction item BrakingForce;
            #controlAction item SteeringForce;
            #controlAction item IntentionToTravel;
            #controlAction item IntentionToLeave;
            #controlAction item EmergencyCall;
            
            // Feedback
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
                ref part :>> controllersRef = (Ushift.ControlElectronics, Teleoperator, Passenger, OtherTraffic, VRUs, Environment);
                ref part :>> actuatorsRef = Ushift.DriveSystem;
                ref part :>> sensorsRef = Ushift.PerceptionSystem;
                ref part :>> processesRef = VehicleMovement;
                ref item :>> controlActionsRef = (OperationCommand, ManeuverCMD, BrakingForce, SteeringForce, IntentionToTravel, IntentionToLeave, EmergencyCall);
                ref item :>> feedbacksRef = (VehiclePosition, Acceleration, VehicleStatus, RoadIntegrity, RoadSigns, PositionVRUs, PositionOtherTraffic);

                #controller part Ushift {
                    #controller part ControlElectronics {
                        part :>> processBeliefs = (VehicleLimitations, OperationalMode, UnderstandingOfPassengerBehavior, AssumptionAboutRoadInfrastructure, PassengerCapacity);
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
                    part :>> mentalBeliefs = CurrentWorkload;
                    #mentalModel part CurrentWorkload;
                }
                #controllerHuman part Passenger {
                    part :>> mentalBeliefs = UnderstandingOfVehicleBehavior;
                    #mentalModel part UnderstandingOfVehicleBehavior;
                }
                #controller part OtherTraffic;
                #controller part VRUs;
                #controller part Environment;
                #process part VehicleMovement;
            }

            // Teleoperator to ControlElectronics
            flow of OperationCommand : ControlAction from UshiftCS.Teleoperator to UshiftCS.Ushift.ControlElectronics;
            // ControlElectronics to Teleoperator
            flow of VehicleStatus : Feedback from UshiftCS.Ushift.ControlElectronics to UshiftCS.Teleoperator;
            // Control to Drive
            flow of ManeuverCMD : ControlAction from UshiftCS.Ushift.ControlElectronics to UshiftCS.Ushift.DriveSystem;
            // Drive to Process
            flow of BrakingForce : ControlAction from UshiftCS.Ushift.DriveSystem to UshiftCS.VehicleMovement;
            flow of SteeringForce : ControlAction from UshiftCS.Ushift.DriveSystem to UshiftCS.VehicleMovement;          
            // Process to Perception
            flow of Acceleration : ControlAction from UshiftCS.VehicleMovement to UshiftCS.Ushift.PerceptionSystem;
            // Environment to Perception
            flow of RoadIntegrity : Feedback from UshiftCS.Environment to UshiftCS.Ushift.PerceptionSystem;
            flow of RoadSigns : Feedback from UshiftCS.Environment to UshiftCS.Ushift.PerceptionSystem;
            // VRU to Perception
            flow of PositionVRUs : Feedback from UshiftCS.VRUs to UshiftCS.Ushift.PerceptionSystem;
            // OtherTraffic to Perception
            flow of PositionOtherTraffic : Feedback from UshiftCS.OtherTraffic to UshiftCS.Ushift.PerceptionSystem;
            // Perception to ControlElectronics
            flow of VehiclePosition : Feedback from UshiftCS.Ushift.PerceptionSystem to UshiftCS.Ushift.ControlElectronics;
            flow of PositionVRUs : Feedback from UshiftCS.Ushift.PerceptionSystem to UshiftCS.Ushift.ControlElectronics;
            flow of RoadIntegrity : Feedback from UshiftCS.Ushift.PerceptionSystem to UshiftCS.Ushift.ControlElectronics;
            flow of PositionOtherTraffic : Feedback from UshiftCS.Ushift.PerceptionSystem to UshiftCS.Ushift.ControlElectronics;
            flow of RoadSigns : Feedback from UshiftCS.Ushift.PerceptionSystem to UshiftCS.Ushift.ControlElectronics;
            // Passenger to ControlElectronics
            flow of IntentionToTravel : ControlAction from UshiftCS.Passenger to UshiftCS.Ushift.ControlElectronics;
            flow of IntentionToLeave : ControlAction from UshiftCS.Passenger to UshiftCS.Ushift.ControlElectronics;
            flow of EmergencyCall : ControlAction from UshiftCS.Passenger to UshiftCS.Ushift.ControlElectronics;
        }
    }
    
    package IdentifyUCAs {
        package Contexts {
            // Context = ⟨SystemConditions⟩ & ⟨EnvironmentalConditions⟩
            #context part EmergencyStateDueToClosedOneWayStreet {
                ref part :>> systemConditions = EmergencyState;
                ref part :>> environmentalConditions = ClosedOneWayStreet;
            }
            #sysCon part EmergencyState;
            #envCon part ClosedOneWayStreet;
        }
        package UCAs {
            // UCA = <Source> & <Type> & <ControlAction> & <Receiver> & <Context> & [Hazards]
            #uca item TeleoperatorDoesNotProvideOperationCommand {
                doc /* Teleoperator does not provide operation command when the automated vehicle is in an emergency situation */
                ref part :>> sourceRef = ModelControlStructure::Structure::UshiftCS.Teleoperator;
                ref item :>> controlActionRef = ModelControlStructure::Interactions::OperationCommand;
                ref enum :>> typeRef = typesOfCAs.NotProvided;
                ref part :>> receiverRef = ModelControlStructure::Structure::UshiftCS.Ushift.ControlElectronics;
                ref part :>> contextRef = Contexts::EmergencyStateDueToClosedOneWayStreet;
                ref part :>> hazardsRef = DefineAnalysisPurpose::Hazards::VehicleCanNotExecuteMission;   
            }
        }
    }
    
    package IdentifyLSs {
        package CausalFactors {
            #cf part TeleoperatorNotInformed {
                ref part :>> factorRef = ModelControlStructure::Interactions::VehicleStatus;
                attribute :>> status = "not forwarded";
            }
        }
        package LossScenarios {
            #ls part TeleoperatorNotAwareOfVehiclesEmergencySituation {
                // LS = <CausalFactors> & [UCAs]
                doc /* The automated vehicle drives into a one way street which is closed and can not resolve the situation. However, the teleoperator is not aware that he is responsible for the vehicle. As a result, the teleoperator does not provide a resolving operation command */
                ref part :>> causalFactorsRef = CausalFactors::TeleoperatorNotInformed;
                ref item :>> ucasRef = IdentifyUCAs::UCAs::TeleoperatorDoesNotProvideOperationCommand;
            }
        }
    }
    
    package Views {
        view ShowLosses : DefineLosses::LossTree {
            expose DefineAnalysisPurpose::Losses::*;
        }
    }
}