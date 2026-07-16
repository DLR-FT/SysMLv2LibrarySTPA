package PaperExample {
    private import LibrarySTPA::DefineAnalysisPurpose::*;
    private import LibrarySTPA::ModelControlStructure::*;
    private import LibrarySTPA::IdentifyUCAs::*;
    private import LibrarySTPA::IdentifyLSs::*;
    private import LibrarySTPA::MetaTypesSTPA::*;
    private import LibrarySTPA::ViewsAndViewpoints::DefineAnalysisPurposeViews::*;
    package DefineAnalysisPurpose {
        package Stakeholders {
            part def Passenger;
            part def Manufacturer;
            part def Operator;
            concern Safety {
                subject Ushift;
                stakeholder : Passenger;
                stakeholder : Manufacturer;
                stakeholder : Operator;
            }
            concern Reputation {
                subject Ushift;
                stakeholder : Manufacturer;
                stakeholder : Operator;
            }
        }
        package Losses {
            #loss occurrence LossOfCustomerSatisfaction {
                :>> stakeholderConcern = Stakeholders::Reputation;
            }
            #loss occurrence LossOfLife {
                :>> stakeholderConcern = Stakeholders::Safety;
            }
        }
        package Hazards {
            #hazard occurrence VehicleCanNotExecuteMission {
                :>> lossesRef = (Losses::LossOfCustomerSatisfaction, Losses::LossOfLife);
            }
            #hazard occurrence VehicleTooCloseToPeople {
                :>> lossesRef = Losses::LossOfLife;
            }
        }
    }
    package ModelControlStructure {
        #controlStructure part UshiftCS {
            :>> controllersRef = (Ushift.ControlElectronics, Teleoperator, Passenger, OtherTraffic, VRUs, Environment);
            :>> actuatorsRef = Ushift.DriveSystem;
            :>> sensorsRef = Ushift.PerceptionSystem;
            :>> processesRef = VehicleMovement;
            :>> controlActionsRef = (teleoperatorCMD, maneuverCMD, vehicleForces, travelCMD);
            :>> feedbacksRef = (vehiclePerception, vehicleMovement, vehicleHealth, vehicleStatus, roadPerception, vruPerception, otherTrafficPerception);
            #controller part Ushift {
                #controller part ControlElectronics {
                    :>> processBeliefs = (VehicleLimitations, OperationalMode, UnderstandingOfPassengerBehavior, AssumptionAboutRoadInfrastructure, PassengerCapacity);
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
            #controlAction flow teleoperatorCMD {
                end ::> Teleoperator;
                end ::> Ushift.ControlElectronics;
            }
            #feedback flow vehicleHealth {
                end ::> Ushift.ControlElectronics;
                end ::> Teleoperator;
            }
            #feedback flow vehicleStatus {
                end ::> Ushift.ControlElectronics;
                end ::> Passenger;
            }
            #controlAction flow maneuverCMD {
                end ::> Ushift.ControlElectronics;
                end ::> Ushift.DriveSystem;
            }
            #controlAction flow vehicleForces {
                end ::> Ushift.DriveSystem;
                end ::> VehicleMovement;
            }
            #feedback flow vehicleMovement {
                end ::> VehicleMovement;
                end ::> Ushift.PerceptionSystem;
            }
            #feedback flow roadPerception {
                end ::> Environment;
                end ::> Ushift.PerceptionSystem;
            }
            #feedback flow vruPerception {
                end ::> VRUs;
                end ::> Ushift.PerceptionSystem;
            }
            #feedback flow otherTrafficPerception {
                end ::> OtherTraffic;
                end ::> Ushift.PerceptionSystem;
            }
            #feedback flow vehiclePerception {
                end ::> Ushift.PerceptionSystem;
                end ::> Ushift.ControlElectronics;
            }
            #controlAction flow travelCMD {
                end ::> Passenger;
                end ::> Ushift.ControlElectronics;
            }
            doc /* This shows a simplified control structure of DLR's Ushift concept vehicle using the defined element types of the SysML v2 library for SysML v2*/
        }
    }
    package IdentifyUCAs {
        package Contexts {
            #context occurrence EmergencyStateDueToClosedOneWayStreet {
                :>> systemConditions = EmergencyState;
                :>> environmentalConditions = ClosedOneWayStreet;
            }
            #sysCon occurrence EmergencyState;
            #envCon occurrence ClosedOneWayStreet;
        }
        package UCAs {
            #uca occurrence TeleoperatorDoesNotProvideOperationCommand {
                doc /* Teleoperator does not provide operation command when the automated vehicle is in an emergency situation */
                :>> sourceRef = ModelControlStructure::UshiftCS.Teleoperator;
                :>> controlActionRef = ModelControlStructure::UshiftCS.teleoperatorCMD;
                :>> typeRef = typesOfCAs.NotProvided;
                :>> receiverRef = ModelControlStructure::UshiftCS.Ushift.ControlElectronics;
                :>> contextRef = Contexts::EmergencyStateDueToClosedOneWayStreet;
                :>> hazardsRef = DefineAnalysisPurpose::Hazards::VehicleCanNotExecuteMission;
            }
        }
    }
    package IdentifyLSs {
        package CausalFactors {
            #cf occurrence TeleoperatorNotInformed {
                :>> factorRef = ModelControlStructure::UshiftCS.vehicleStatus;
                attribute :>> status = "not forwarded";
            }
        }
        package LossScenarios {
            #ls occurrence TeleoperatorNotAwareOfVehiclesEmergencySituation {
                doc /* The automated vehicle drives into a one way street which is closed and can not resolve the situation. However, the teleoperator is not aware that he is responsible for the vehicle. As a result, the teleoperator does not provide a resolving operation command */
                :>> causalFactorsRef = CausalFactors::TeleoperatorNotInformed;
                :>> ucasRef = IdentifyUCAs::UCAs::TeleoperatorDoesNotProvideOperationCommand;
            }
        }
    }
    //package ViewsCameo {
    //    private import CameoViewsSTPA::**;

    //    view ShowLosses : DefineLosses::LossTree {
    //        expose DefineAnalysisPurpose::Losses::*;
    //    }
    //    view HazardsAndLosses : HazardsTable {
    //        expose DefineAnalysisPurpose::**;
    //        filter @hazard;
    //    }
    //    view UCAs : UCAsTable {
    //        expose IdentifyUCAs::**;
    //        filter @uca;
    //    }
    //    view LSs : LSsTable {
    //        expose IdentifyLSs::**;
    //        filter @ls;
    //    }
    //    package ControlStructureDemo {
    //        view ControlStructureDemo : CameoViewsSTPA::CustomViewsSTPA::'STPA View';
    //    }
    //}
}