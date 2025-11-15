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
                :>> controllers = (Ushift.ControlElectronics, Teleoperator, Passenger, OtherTraffic, VRUs, Environment);
                :>> actuators = Ushift.DriveSystem;
                :>> sensors = Ushift.PerceptionSystem;
                :>> processes = VehicleMovement;
            }

            #controller part Ushift {
                #controller part ControlElectronics {
                    :>> processModels = (VehicleLimitations, OperationalMode, UnderstandingOfPassengerBehavior, AssumptionAboutRoadInfrastructure, PassengerCapacity);
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
                :>> mentalModels = CurrentWorkload;
                #mentalModel CurrentWorkload;
            }
            #controllerHuman part Passenger {
                :>> mentalModels = UnderstandingOfVehicleBehavior;
                #mentalModel part UnderstandingOfVehicleBehavior;
            }
            #controller part OtherTraffic;
            #controller part VRUs;
            #controller part Environment;
            #process part VehicleMovement;

            // Teleoperator to ControlElectronics
            flow of OperationCommand from Teleoperator to Ushift.ControlElectronics;
            // ControlElectronics to Teleoperator
            flow of VehicleStatus from Ushift.ControlElectronics to Teleoperator;
            // Control to Drive
            flow of ManeuverCMD from Ushift.ControlElectronics to Ushift.DriveSystem;
            // Drive to Process
            flow of BrakingForce from Ushift.DriveSystem to Ushift.VehicleMovement;
            flow of SteeringForce from Ushift.DriveSystem to VehicleMovement;          
            // Process to Perception
            flow of Acceleration from VehicleMovement to Ushift.PerceptionSystem;
            // Environment to Perception
            flow of RoadIntegrity from Environment to Ushift.PerceptionSystem;
            flow of RoadSigns from Environment to Ushift.PerceptionSystem;
            // VRU to Perception
            flow of PositionVRUs from VRUs to Ushift.PerceptionSystem;
            // OtherTraffic to Perception
            flow of PositionOtherTraffic from OtherTraffic to Ushift.PerceptionSystem;
            // Perception to ControlElectronics
            flow of VehiclePosition from Ushift.PerceptionSystem to Ushift.ControlElectronics;
            flow of PositionVRUs from Ushift.PerceptionSystem to Ushift.ControlElectronics;
            flow of RoadIntegrity from Ushift.PerceptionSystem to Ushift.ControlElectronics;
            flow of PositionOtherTraffic from Ushift.PerceptionSystem to Ushift.ControlElectronics;
            flow of RoadSigns from Ushift.PerceptionSystem to Ushift.ControlElectronics;
            // Passenger to ControlElectronics
            flow of IntentionToTravel from Passenger to Ushift.ControlElectronics;
            flow of IntentionToLeave from Passenger to Ushift.ControlElectronics;
            flow of EmergencyCall from Passenger to Ushift.ControlElectronics;
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
                :>> source = ModelControlStructure::Structure::Teleoperator;
                :>> controlAction = ModelControlStructure::Interactions::OperationCommand;
                :>> type = typesOfCAs.NotProvided;
                :>> receiver = ModelControlStructure::Structure::Ushift.ControlElectronics;
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