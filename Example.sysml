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
                stakeholder Passenger;
                stakeholder Manufacturer;
                stakeholder Operator;
            }
            concern Reputation {
                stakeholder Manufacturer;
                stakeholder Operator;
            }
            concern Revenue {
                stakeholder Manufacturer;
                stakeholder Operator;
            }
        }
        package Losses {            
            #loss LossOfCustomerSatisfaction {
                :>> stakeholderConcern = Stakeholders::Reputation;
            }
            #loss DamageToInfrastructure {
                :>> stakeholderConcern = Stakeholders::Revenue;
            }
            #loss LossOfLife {
                :>> stakeholderConcern = Stakeholders::Safety;
            }
        }
        package Hazards {
            #hazard VehicleCanNotExecuteMission {
                :>> linkedLosses = Losses::LossOfCustomerSatisfaction;
            }
            #hazard VehicleComesToCloseToInfrastructure {
                :>> linkedLosses = Losses::DamageToInfrastructure;
            }
            #hazard VehicleComesTocloseToPeople {
                :>> linkedLosses = Losses::LossOfLife;
            }
        }
    }
    
    package ModelControlStructure {
        package Interactions {
            // Control Actions
            #controlAction OperationCommand;
            #controlAction ManeuverCMD;
            #controlAction BrakingForce;
            #controlAction SteeringForce;
            #controlAction IntentionToTravel;
            #controlAction IntentionToLeave;
            #controlAction EmergencyCall;
            
            // Feedback
            #feedback VehiclePosition;
            #feedback Acceleration;
            #feedback VehicleStatus;
            #feedback RoadIntegrity;
            #feedback RoadSigns;
            #feedback PositionVRUs;
            #feedback PositionOtherTraffic;
        }
        package Structure {
            part ControlStructureUshift{
                #controllerHuman Teleoperator {
                    //:>> mentalModels = CurrentWorkload;
                    #mentalModel CurrentWorkload;
                }
                #controller ControlElectronics {
                    //:>> processModels = VehicleLimitations;
                    #processModel VehicleLimitations;
                    #processModel OperationalMode;
                    #processModel UnderstandingOfPassengerBehavior;
                    #processModel AssumptionAboutRoadInfrastructure;
                    #processModel PassengerCapacity;
                }
                #sensor PerceptionSystem;
                #actuator DriveSystem;
                #controllerHuman Passenger {
                    #mentalModel UnderstandingOfVehicleBehavior;
                }
                #controller OtherTraffic;
                #controller VRUs;
                #controller Environment;
                #process VehicleMovement;
            }
            // Teleoperator to ControlElectronics
            flow of Interactions::OperationCommand from ControlStructureUshift.Teleoperator to ControlStructureUshift.ControlElectronics;
            // ControlElectronics to Teleoperator
            flow of Interactions::VehicleStatus from ControlStructureUshift.ControlElectronics to ControlStructureUshift.Teleoperator;
            // Control to Drive
            flow of Interactions::ManeuverCMD from ControlStructureUshift.ControlElectronics to ControlStructureUshift.DriveSystem;
            // Drive to Process
            flow of Interactions::BrakingForce from ControlStructureUshift.DriveSystem to ControlStructureUshift.VehicleMovement;
            flow of Interactions::SteeringForce from ControlStructureUshift.DriveSystem to ControlStructureUshift.VehicleMovement;          
            // Process to Perception
            flow of Interactions::Acceleration from ControlStructureUshift.VehicleMovement to ControlStructureUshift.PerceptionSystem;
            // Environment to Perception
            flow of Interactions::RoadIntegrity from ControlStructureUshift.Environment to ControlStructureUshift.PerceptionSystem;
            flow of Interactions::RoadSigns from ControlStructureUshift.Environment to ControlStructureUshift.PerceptionSystem;
            // VRU to Perception
            flow of Interactions::PositionVRUs from ControlStructureUshift.VRUs to ControlStructureUshift.PerceptionSystem;
            // OtherTraffic to Perception
            flow of Interactions::PositionOtherTraffic from ControlStructureUshift.OtherTraffic to ControlStructureUshift.PerceptionSystem;
            // Perception to ControlElectronics
            flow of Interactions::VehiclePosition from ControlStructureUshift.PerceptionSystem to ControlStructureUshift.ControlElectronics;
            flow of Interactions::PositionVRUs from ControlStructureUshift.PerceptionSystem to ControlStructureUshift.ControlElectronics;
            flow of Interactions::RoadIntegrity from ControlStructureUshift.PerceptionSystem to ControlStructureUshift.ControlElectronics;
            flow of Interactions::PositionOtherTraffic from ControlStructureUshift.PerceptionSystem to ControlStructureUshift.ControlElectronics;
            flow of Interactions::RoadSigns from ControlStructureUshift.PerceptionSystem to ControlStructureUshift.ControlElectronics;
            // Passenger to ControlElectronics
            flow of Interactions::IntentionToTravel from ControlStructureUshift.Passenger to ControlStructureUshift.ControlElectronics;
            flow of Interactions::IntentionToLeave from ControlStructureUshift.Passenger to ControlStructureUshift.ControlElectronics;
            flow of Interactions::EmergencyCall from ControlStructureUshift.Passenger to ControlStructureUshift.ControlElectronics;
        }
    }
    
    package IdentifyUCAs {
        package Contexts {
            // Context = ⟨SystemConditions⟩ & ⟨EnvironmentalConditions⟩
            #context EmergencyStateDueToClosedOneWayStreet {
                :>> systemConditions = EmergencyState;
                :>> environmentalConditions = ClosedOneWayStreet;
            }
            #sysCon EmergencyState;
            #envCon ClosedOneWayStreet;
        }
        package UCAs {
            // UCA = <Source> & <Type> & <ControlAction> & <Receiver> & <Context> & [Hazards]
            #uca TeleoperatorDoesNotProvideOperationCommand : UnsafeControlAction {
                :>> description = "Teleoperator does not provide operation command when the automated vehicle is in an emergency situation";
                :>> source = ModelControlStructure::Structure::ControlStructureUshift.Teleoperator;
                :>> controlAction = ModelControlStructure::Interactions::OperationCommand;
                :>> type = typesOfCA.NotProvided;
                :>> receiver = ModelControlStructure::Structure::ControlStructureUshift.ControlElectronics;
                :>> contextUCA = Contexts::EmergencyStateDueToClosedOneWayStreet;
                :>> linkedHazards = DefineAnalysisPurpose::Hazards::VehicleCanNotExecuteMission;   
            }
        }
    }
    
    package IdentifyLSs {
        package CausalFactors {
            #cf TeleoperatorNotInformed {
                :>> factor = ModelControlStructure::Interactions::VehicleStatus;
                :>> status = "not forwarded";
            }
        }
        package LossScenarios {
            #ls TeleoperatorNotAwareOfVehiclesEmergencySituation {   
                // LS = <CausalFactors> & [UCAs]
                :>> description = "The automated vehicle drives into a one way street which is closed and can not resolve the situation. However, the teleoperator is not aware that he is responsible for the vehicle. As a result, the teleoperator does not provide a resolving operation command.";
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