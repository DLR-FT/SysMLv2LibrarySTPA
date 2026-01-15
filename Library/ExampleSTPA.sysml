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
                ref concern :>> stakeholderConcern = Stakeholders::Reputation;
            }
            #loss occurrence LossOfLife {
                ref concern :>> stakeholderConcern = Stakeholders::Safety;
            }
        }
        package Hazards {
            #hazard occurrence VehicleCanNotExecuteMission {
                ref occurrence :>> lossesRef = (Losses::LossOfCustomerSatisfaction, Losses::LossOfLife);
            }
            #hazard occurrence VehicleTooCloseToPeople {
                ref occurrence :>> lossesRef = Losses::LossOfLife;
            }
        }
    }
    package ModelControlStructure {
        #controlStructure part UshiftCS {
            ref part :>> controllersRef = (Ushift.ControlElectronics, Teleoperator, Passenger, OtherTraffic, VRUs, Environment);
            ref part :>> actuatorsRef = Ushift.DriveSystem;
            ref part :>> sensorsRef = Ushift.PerceptionSystem;
            ref part :>> processesRef = VehicleMovement;
            ref flow :>> controlActionsRef = (teleoperatorCMD, maneuverCMD, vehicleForces, travelCMD);
            ref flow :>> feedbacksRef = (vehiclePerception, vehicleMovement, vehicleHealth, vehicleStatus, roadPerception, vruPerception, otherTrafficPerception);
            #controller part Ushift {
                #controller part ControlElectronics {
                    ref part :>> processBeliefs = (VehicleLimitations, OperationalMode, UnderstandingOfPassengerBehavior, AssumptionAboutRoadInfrastructure,
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
                ref part :>> mentalBeliefs = CurrentWorkload;
                #mentalModel part CurrentWorkload;
            }
            #controllerHuman part Passenger {
                ref part :>> mentalBeliefs = UnderstandingOfVehicleBehavior;
                #mentalModel part UnderstandingOfVehicleBehavior;
            }
            #controller part OtherTraffic;
            #controller part VRUs;
            #controller part Environment;
            #process part VehicleMovement;
            #controlAction flow teleoperatorCMD from Teleoperator.interactionsOut to UshiftCS::Ushift::ControlElectronics.interactionsIn;
            #feedback flow vehicleHealth from UshiftCS::Ushift::ControlElectronics.interactionsOut to Teleoperator.interactionsIn;
            #feedback flow vehicleStatus from UshiftCS::Ushift::ControlElectronics.interactionsOut to Passenger.interactionsIn;
            #controlAction flow maneuverCMD from UshiftCS::Ushift::ControlElectronics.interactionsOut to Ushift::DriveSystem.interactionsIn;
            #controlAction flow vehicleForces from Ushift::DriveSystem.interactionsOut to VehicleMovement.interactionsIn;
            #feedback flow vehicleMovement from VehicleMovement.interactionsOut to Ushift::PerceptionSystem.interactionsIn;
            #feedback flow roadPerception from Environment.interactionsOut to Ushift::PerceptionSystem.interactionsIn;
            #feedback flow vruPerception from VRUs.interactionsOut to Ushift::PerceptionSystem.interactionsIn;
            #feedback flow otherTrafficPerception from OtherTraffic.interactionsOut to Ushift::PerceptionSystem.interactionsIn;
            #feedback flow vehiclePerception from Ushift::PerceptionSystem.interactionsOut to UshiftCS::Ushift::ControlElectronics.interactionsIn;
            #controlAction flow travelCMD from Passenger.interactionsOut to UshiftCS::Ushift::ControlElectronics.interactionsIn;
            doc /* This shows a simplified control structure of DLR's Ushift concept vehicle using the defined element types of the SysML v2 library for SysML v2*/
        }
    }
    package IdentifyUCAs {
        package Contexts {
            #context occurrence EmergencyStateDueToClosedOneWayStreet {
                ref occurrence :>> systemConditions = EmergencyState;
                ref occurrence :>> environmentalConditions = ClosedOneWayStreet;
            }
            #sysCon occurrence EmergencyState;
            #envCon occurrence ClosedOneWayStreet;
        }
        package UCAs {
            #uca occurrence TeleoperatorDoesNotProvideOperationCommand {
                doc /* Teleoperator does not provide operation command when the automated vehicle is in an emergency situation */
                ref part :>> sourceRef = ModelControlStructure::UshiftCS.Teleoperator;
                ref flow :>> controlActionRef = ModelControlStructure::UshiftCS.teleoperatorCMD;
                enum :>> typeRef = typesOfCAs.NotProvided;
                ref part :>> receiverRef = ModelControlStructure::UshiftCS::Ushift.ControlElectronics;
                ref occurrence :>> contextRef = Contexts::EmergencyStateDueToClosedOneWayStreet;
                ref occurrence :>> hazardsRef = DefineAnalysisPurpose::Hazards::VehicleCanNotExecuteMission;
            }
        }
    }
    package IdentifyLSs {
        package CausalFactors {
            #cf occurrence TeleoperatorNotInformed {
                ref occurrence :>> factorRef = ModelControlStructure::UshiftCS.vehicleStatus;
                attribute :>> status = "not forwarded";
            }
        }
        package LossScenarios {
            #ls occurrence TeleoperatorNotAwareOfVehiclesEmergencySituation {
                doc /* The automated vehicle drives into a one way street which is closed and can not resolve the situation. However, the teleoperator is not aware that he is responsible for the vehicle. As a result, the teleoperator does not provide a resolving operation command */
                ref occurrence :>> causalFactorsRef = CausalFactors::TeleoperatorNotInformed;
                ref occurrence :>> ucasRef = IdentifyUCAs::UCAs::TeleoperatorDoesNotProvideOperationCommand;
            }
        }
    }
    package Views {
        //private import CameoViewsSTPA::**;
        //view HazardsAndLosses : HazardsTable {
        //    expose PaperExample::DefineAnalysisPurpose::**;
        //    filter @hazard;
        //}
        //view UCAs : UCAsTable {
        //    expose PaperExample::IdentifyUCAs::**;
        //    filter @uca;
        //}
        //view LSs : LSsTable {
        //    expose PaperExample::IdentifyLSs::**;
        //    filter @ls;
        //}
        view ShowLosses : DefineLosses::LossTree {
            expose DefineAnalysisPurpose::Losses::*;
        }
    }
}