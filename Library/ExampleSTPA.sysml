package PaperExample {
 
    private import LibrarySTPA::DefineAnalysisPurposeSTPA::*;
    private import LibrarySTPA::ModelControlStructureSTPA::*;
    private import LibrarySTPA::IdentifyUCAsSTPA::*;
    private import LibrarySTPA::IdentifyLSsSTPA::*;
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
                :>> linkedLosses = Losses::LossOfCustomerSatisfaction;
            }
            #hazard part VehicleComesToCloseToInfrastructure {
                :>> linkedLosses = Losses::DamageToInfrastructure;
            }
            #hazard part VehicleComesTocloseToPeople {
                :>> linkedLosses = Losses::LossOfLife;
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

            #controlStructure part UshiftAnalysis {
                :>> controllers = (DesignContext.Ushift.ControlElectronics, DesignContext.Teleoperator, DesignContext.Passenger, DesignContext.OtherTraffic, DesignContext.VRUs, DesignContext.Environment);
                :>> actuators = DesignContext.Ushift.DriveSystem;
                :>> sensors = DesignContext.Ushift.PerceptionSystem;
                :>> processes = DesignContext.VehicleMovement;
            }

            part DesignContext {
                #controller part Ushift {
                    #controller part ControlElectronics {
                        :>> processMods = (VehicleLimitations, OperationalMode, UnderstandingOfPassengerBehavior, AssumptionAboutRoadInfrastructure, PassengerCapacity);
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
                    :>> mentalMods = CurrentWorkload;
                    #mentalModel CurrentWorkload;
                }
                #controllerHuman part Passenger {
                    :>> mentalMods = UnderstandingOfVehicleBehavior;
                    #mentalModel part UnderstandingOfVehicleBehavior;
                }
                #controller part OtherTraffic;
                #controller part VRUs;
                #controller part Environment;
                #process part VehicleMovement;
            }

            // Teleoperator to ControlElectronics
            flow of OperationCommand from DesignContext.Teleoperator to DesignContext.Ushift.ControlElectronics;
            // ControlElectronics to Teleoperator
            flow of VehicleStatus from DesignContext.Ushift.ControlElectronics to DesignContext.Teleoperator;
            // Control to Drive
            flow of ManeuverCMD from DesignContext.Ushift.ControlElectronics to DesignContext.Ushift.DriveSystem;
            // Drive to Process
            flow of BrakingForce from DesignContext.Ushift.DriveSystem to DesignContext.VehicleMovement;
            flow of SteeringForce from DesignContext.Ushift.DriveSystem to DesignContext.VehicleMovement;          
            // Process to Perception
            flow of Acceleration from DesignContext.VehicleMovement to DesignContext.Ushift.PerceptionSystem;
            // Environment to Perception
            flow of RoadIntegrity from DesignContext.Environment to DesignContext.Ushift.PerceptionSystem;
            flow of RoadSigns from DesignContext.Environment to DesignContext.Ushift.PerceptionSystem;
            // VRU to Perception
            flow of PositionVRUs from DesignContext.VRUs to DesignContext.Ushift.PerceptionSystem;
            // OtherTraffic to Perception
            flow of PositionOtherTraffic from DesignContext.OtherTraffic to DesignContext.Ushift.PerceptionSystem;
            // Perception to ControlElectronics
            flow of VehiclePosition from DesignContext.Ushift.PerceptionSystem to DesignContext.Ushift.ControlElectronics;
            flow of PositionVRUs from DesignContext.Ushift.PerceptionSystem to DesignContext.Ushift.ControlElectronics;
            flow of RoadIntegrity from DesignContext.Ushift.PerceptionSystem to DesignContext.Ushift.ControlElectronics;
            flow of PositionOtherTraffic from DesignContext.Ushift.PerceptionSystem to DesignContext.Ushift.ControlElectronics;
            flow of RoadSigns from DesignContext.Ushift.PerceptionSystem to DesignContext.Ushift.ControlElectronics;
            // Passenger to ControlElectronics
            flow of IntentionToTravel from DesignContext.Passenger to DesignContext.Ushift.ControlElectronics;
            flow of IntentionToLeave from DesignContext.Passenger to DesignContext.Ushift.ControlElectronics;
            flow of EmergencyCall from DesignContext.Passenger to DesignContext.Ushift.ControlElectronics;
        }
    }
    
    package IdentifyUCAs {
        package Contexts {
            // Context = ⟨SystemConditions⟩ & ⟨EnvironmentalConditions⟩
            #context part EmergencyStateDueToClosedOneWayStreet {
                :>> systemConditions = EmergencyState;
                :>> environmentalConditions = ClosedOneWayStreet;
            }
            #sysCon part EmergencyState;
            #envCon part ClosedOneWayStreet;
        }
        package UCAs {
            // UCA = <Source> & <Type> & <ControlAction> & <Receiver> & <Context> & [Hazards]
            #uca item TeleoperatorDoesNotProvideOperationCommand {
                doc /* Teleoperator does not provide operation command when the automated vehicle is in an emergency situation */
                :>> source = ModelControlStructure::Structure::DesignContext.Teleoperator;
                :>> controlAction = ModelControlStructure::Interactions::OperationCommand;
                :>> type = typesOfCAs.NotProvided;
                :>> receiver = ModelControlStructure::Structure::DesignContext.Ushift.ControlElectronics;
                :>> contextUCA = Contexts::EmergencyStateDueToClosedOneWayStreet;
                :>> linkedHazards = DefineAnalysisPurpose::Hazards::VehicleCanNotExecuteMission;   
            }
        }
    }
    
    package IdentifyLSs {
        package CausalFactors {
            #cf part TeleoperatorNotInformed {
                :>> factor = ModelControlStructure::Interactions::VehicleStatus;
                :>> status = "not forwarded";
            }
        }
        package LossScenarios {
            #ls part TeleoperatorNotAwareOfVehiclesEmergencySituation {
                // LS = <CausalFactors> & [UCAs]
                doc /* The automated vehicle drives into a one way street which is closed and can not resolve the situation. However, the teleoperator is not aware that he is responsible for the vehicle. As a result, the teleoperator does not provide a resolving operation command */
                :>> scenarioFactors = CausalFactors::TeleoperatorNotInformed;
                :>> ucas = IdentifyUCAs::UCAs::TeleoperatorDoesNotProvideOperationCommand;
            }
        }
    }
    
    package Views {
        view ShowLosses : DefineLosses::LossTree {
            expose DefineAnalysisPurpose::Losses::*;
        }
    }
}